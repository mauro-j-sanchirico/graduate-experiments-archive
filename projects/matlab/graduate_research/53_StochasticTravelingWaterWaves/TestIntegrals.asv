clc; clear; close all;

x_c = 5;
t_c = 0;
ka = 0.9;
kb = 1.2;
j = 8;

in = compute_numerical_integral(ka, kb, j, x_c, t_c)
ia = compute_analytical_f_integral(ka, kb, j, x_c, t_c)
error = ia - in

function integral = compute_numerical_integral(ka, kb, j, x_c, t_c)
    k = ka:0.0001:kb;
    integrand = k.^2.*(k*x_c - 4*k.^3*t_c).^j;
    integral = trapz(k, integrand);
end