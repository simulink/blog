function metrics = analyzeCraneClearance(p, simOut)
%ANALYZECRANECLEARANCE Measure obstacle crossing clearance from simulation.

xBob = simOut.get("xBob");
yBob = simOut.get("yBob");
contactForce = simOut.get("contactForce");

x = xBob.Data;
y = yBob.Data;
t = xBob.Time;
wallTop = p.wallBaseY + p.wallHeight;

crossingIdx = find((x(1:end-1) - p.wallX) .* (x(2:end) - p.wallX) <= 0);
clearances = zeros(numel(crossingIdx), 1);
times = zeros(numel(crossingIdx), 1);
for k = 1:numel(crossingIdx)
    i = crossingIdx(k);
    alpha = (p.wallX - x(i)) / (x(i+1) - x(i) + eps);
    times(k) = t(i) + alpha * (t(i+1) - t(i));
    yCross = y(i) + alpha * (y(i+1) - y(i));
    clearances(k) = yCross - wallTop;
end

metrics.crossingTimes = times;
metrics.crossingClearances = clearances;
metrics.minCrossingClearance = min(clearances, [], "omitmissing");
metrics.maxPayloadHeight = max(y);
metrics.maxContactForce = max(contactForce.Data);
metrics.crossingCount = numel(crossingIdx);
end
