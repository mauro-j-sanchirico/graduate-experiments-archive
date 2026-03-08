clc; clear; close all;

num_partial_sum_terms_n_s = 50;

v_values = -5*pi:0.1:5*pi;

lhs = tanh(v_values);
rhs = zeros(size(v_values));

linear_convergence_constant_q_1 = 0.8129;
linear_convergence_constant_q_0 = 1.3991;

upper_radius_of_convergence_rho = ...
    linear_convergence_constant_q_1*num_partial_sum_terms_n_s ...
  + linear_convergence_constant_q_0;

r = 1.1;

adjusted_upper_radius_of_convergence_rho_v = ...
    upper_radius_of_convergence_rho / (r*max(v_values));
  
xi = 0.001:0.001:adjusted_upper_radius_of_convergence_rho_v;

for idx = 1:length(v_values)
    
    sum = 0;
    v = v_values(idx);
    
    for m = 1:num_partial_sum_terms_n_s
        
        integrand = xi.^(2*m-1).*csch((pi/2)*xi);
        integral = trapz(xi, integrand);
        numerator = (-1)^(m-1)*v^(2*m-1);
        denominator = factorial(2*m-1);
        term = integral*numerator/denominator;
        sum = sum + term;
    end
    
    rhs(idx) = sum;
    
end

error = abs(lhs - rhs);

% ends are where divergence occurs, select the convergent region
selection = abs(v_values) < max(v_values)*0.9;

figure;
plot(v_values(selection), lhs(selection));
hold on;
plot(v_values(selection), rhs(selection));

figure;
semilogy(v_values(selection), error(selection));

mse = mean(error.^2)
