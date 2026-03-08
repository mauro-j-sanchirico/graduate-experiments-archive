function dxdt = GetLinearSpringState(~, x, k)
dxdt = [x(2); -k*x(1)];
end
