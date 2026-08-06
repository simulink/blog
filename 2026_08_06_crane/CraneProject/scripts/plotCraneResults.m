function plotCraneResults(p, metrics, simOut)
%PLOTCRANERESULTS Plot workspace-logged signals from the Simscape run.

if nargin < 1
    p = craneParameters();
end

names = ["xTrolley" "vTrolley" "theta" "omega" "xBob" "yBob" "contactForce"];
data = struct();
for k = 1:numel(names)
    if nargin >= 3 && any(strcmp(who(simOut), names(k)))
        data.(names(k)) = simOut.get(names(k));
    elseif evalin("base", "exist('" + names(k) + "','var')")
        data.(names(k)) = evalin("base", names(k));
    end
end

figure("Name", "Gantry Crane Simscape Results");
tiledlayout(3, 1);

nexttile;
plot(data.xTrolley.Time, data.xTrolley.Data, "LineWidth", 1.2);
yline(p.targetX, "--");
grid on;
ylabel("trolley x (m)");

nexttile;
plot(data.xBob.Time, data.xBob.Data, "LineWidth", 1.2);
hold on;
plot(data.yBob.Time, data.yBob.Data, "LineWidth", 1.2);
yline(p.wallBaseY + p.wallHeight, "--");
grid on;
ylabel("payload pos (m)");
legend("x", "y", "wall top", "Location", "best");

nexttile;
plot(data.theta.Time, data.theta.Data, "LineWidth", 1.2);
hold on;
if isfield(data, "contactForce")
    yyaxis right;
    plot(data.contactForce.Time, data.contactForce.Data, "LineWidth", 1.0);
    ylabel("contact force (N)");
    yyaxis left;
end
grid on;
ylabel("theta (rad)");
xlabel("time (s)");

if nargin > 1
    sgtitle(sprintf("Minimum wall-crossing clearance %.2f m", ...
        metrics.minCrossingClearance));
end
end
