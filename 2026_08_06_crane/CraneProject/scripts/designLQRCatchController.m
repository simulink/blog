function K = designLQRCatchController(p)
%DESIGNLQRCATCHCONTROLLER LQR gain for the small-angle crane model.

if nargin == 0
    p = craneParameters();
end

M = p.trolleyMass;
m = p.payloadMass;
L = p.pendulumLength;
g = p.gravity;

% State vector: [x; xdot; theta; thetaDot]. theta is measured from vertical.
A = [0 1 0 0; ...
     0 0 -(m*g)/M 0; ...
     0 0 0 1; ...
     0 0 ((M+m)*g)/(M*L) 0];
B = [0; 1/M; 0; -1/(M*L)];

K = lqr(A, B, p.lqrQ, p.lqrR);
end
