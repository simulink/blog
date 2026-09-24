classdef GuyOnSimulinkSolver < Simulink.Solver.FixedStepSolver
    properties
        NewtonIterations = 3;
    end

    methods (Static)
        function props = getProperties
            props = struct("MassMatrix",true,"DAE",true,"Jacobian",true);
        end
    end

    methods
        function x1 = step(slvr,t0,x0,h)
            t1 = t0 + h;
            J = slvr.Jacobian(t0,x0);
            M = slvr.massMatrix(t0,x0);
            W = M - h * J;

            x1 = x0;
            z = zeros(size(x0));

            for n = 1:slvr.NewtonIterations
                if slvr.isStateDependentMassMatrix && n > 1
                    M = slvr.massMatrix(t1,x1);
                end
                g = h * slvr.forcingFunction(t1,x1) - M * z;
                dg = W \ g;
                x1 = x1 + dg;
                z = z + dg;
            end
        end
    end
end