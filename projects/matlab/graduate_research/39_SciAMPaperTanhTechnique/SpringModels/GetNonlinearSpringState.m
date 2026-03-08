function dxdt = GetNonlinearSpringState(~, x, k)
dxdt = [x(2); -tanh(k*x(1))];
end
