function y = compute_analytical_f_integral(ka, kb, j, x_c, t_c)
y = compute_big_f(kb, j, x_c, t_c) - compute_big_f(ka, j, x_c, t_c);
end
