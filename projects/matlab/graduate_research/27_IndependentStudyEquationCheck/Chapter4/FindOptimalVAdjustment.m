clc; clear; close all;

r = 0.95:0.01:1.2;
error = zeros(size(r));

% Sweep to find an optimum
for idx = 1:length(r)
    fprintf('Iteration %i / %i\n', idx, length(r));
    error(idx) = EvaluateTanhExpansion(r(idx));
end

figure;
plot(r, error, 'x');
xlabel('r');
ylabel('log10(mse(y, y_a))');
grid on;
[~, best_idx] = min(error);

best_r0 = r(best_idx);
fprintf('Found best r: %f\n', r(best_idx));


function log10_mean_square_error = EvaluateTanhExpansion(r)

num_partial_sum_terms_n_s = 40;

v_values = -4*pi:0.1:4*pi;

lhs = tanh(v_values);
rhs = zeros(size(v_values));

linear_convergence_constant_q_1 = 0.8129;
linear_convergence_constant_q_0 = 1.3991;

upper_radius_of_convergence_rho = ...
    linear_convergence_constant_q_1*num_partial_sum_terms_n_s ...
  + linear_convergence_constant_q_0;

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

log10_mean_square_error = log10(mean(error.^2));

end