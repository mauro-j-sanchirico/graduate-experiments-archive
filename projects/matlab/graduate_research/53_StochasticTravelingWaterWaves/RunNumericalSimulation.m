function [k, u, u_bar, sech2_max_arg] = RunNumericalSimulation( ...
    alpha, delta, ka, kb, dk, x_c, t_c)
    
k = ka:dk:kb;

sech_arg = k*x_c - 4*k.^3*t_c + delta;
u = 12*k.^2 / alpha .* sech(sech_arg).^2;

sech2_max_arg = max(abs(sech_arg));
u_bar = mean(u);

end
