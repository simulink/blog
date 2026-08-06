function [forceCmd, result] = tunePumpManeuver(p)
%TUNEPUMPMANEUVER Generate a pump-and-catch force profile.

if nargin == 0
    p = craneParameters();
end

K = designLQRCatchController(p);
omega0 = sqrt(p.gravity / p.pendulumLength);
freq = p.pumpFrequencyScale * omega0;
dt = 0.01;
t = (0:dt:p.stopTime).';

best = [];
ampGrid = linspace(0.55, 1.0, 5) * p.pumpAmplitude;
durGrid = p.pumpDuration + linspace(-0.6, 0.6, 5);
phaseGrid = linspace(-pi/5, pi/5, 5);

for amp = ampGrid
    for dur = durGrid
        for phase = phaseGrid
            [sim, f] = simulateAnalytic(t, amp, freq, dur, phase, K, p);
            maxForce = max(abs(f));
            clearance = max(sim.yBob - wallTop(p));
            finalError = abs(sim.xTrolley(end) - p.targetX) + abs(sim.theta(end));
            feasible = clearance >= p.clearanceMargin && finalError < 0.45;
            score = maxForce + 200 * max(0, p.clearanceMargin - clearance) + 20 * finalError;
            if isempty(best) || score < best.score || (feasible && ~best.feasible)
                best = struct("amp", amp, "dur", dur, "phase", phase, ...
                    "score", score, "feasible", feasible, "sim", sim, ...
                    "force", f, "clearance", clearance, "finalError", finalError);
            end
        end
    end
end

forceCmd = timeseries(best.force, t);
result = best;
result.frequency = freq;
result.peakForce = max(abs(best.force));
end

function [s, f] = simulateAnalytic(t, amp, freq, pumpDuration, phase, K, p)
x0 = [0; 0; 0; 0];
force = @(tt, xx) commandForce(tt, xx, amp, freq, pumpDuration, phase, K, p);
ode = @(tt, x) craneOde(tt, x, force, p);
[~, x] = ode45(ode, t, x0);
f = zeros(size(t));
for i = 1:numel(t)
    f(i) = commandForce(t(i), x(i,:).', amp, freq, pumpDuration, phase, K, p);
end
s.xTrolley = x(:,1);
s.vTrolley = x(:,2);
s.theta = x(:,3);
s.omega = x(:,4);
s.xBob = s.xTrolley + p.pendulumLength * sin(s.theta);
s.yBob = -p.pendulumLength * cos(s.theta);
end

function u = commandForce(t, x, amp, freq, pumpDuration, phase, K, p)
if t <= pumpDuration
    envelope = sin(pi * t / pumpDuration)^2;
    u = amp * envelope * sin(freq * t + phase);
else
    xCatch = [x(1) - p.targetX; x(2); x(3); x(4)];
    u = -K * xCatch;
end
u = max(min(u, p.forceMax), -p.forceMax);
end

function dx = craneOde(t, x, force, p)
M = p.trolleyMass;
m = p.payloadMass;
L = p.pendulumLength;
g = p.gravity;
u = force(t, x);
theta = x(3);
omega = x(4);
den = M + m * sin(theta)^2;
xdd = (u + m * sin(theta) * (L * omega^2 + g * cos(theta))) / den;
thetadd = -(u * cos(theta) + m * L * omega^2 * sin(theta) * cos(theta) ...
    + (M + m) * g * sin(theta)) / (L * den);
dx = [x(2); xdd; omega; thetadd];
end

function y = wallTop(p)
y = p.wallBaseY + p.wallHeight;
end
