clc; clear; close all;

xi = 0.001:0.001:1000;
m_values = 1:10;
activation_function_constants_phi_eq_4_8 = zeros(size(m_values));
activation_function_constants_phi_eq_4_9 = zeros(size(m_values));

for idx = 1:length(m_values)
    
    m = m_values(idx);
    
    integrand = csch((pi/2)*xi).*xi.^(2*m-1);
    integral = trapz(xi, integrand);
    activation_function_constants_phi_eq_4_8(idx) = integral;
    
    activation_function_constants_phi_eq_4_9(idx) = ...
        (2^(2*m)-1)/(2*m)*2^(2*m)*abs(bernoulli(vpa(2*m)));
    
end

figure;
semilogy(m_values, activation_function_constants_phi_eq_4_8, 'x');
hold on;
semilogy(m_values, activation_function_constants_phi_eq_4_9, 'o');
grid on

error = abs( ...
    activation_function_constants_phi_eq_4_8 ...
  - activation_function_constants_phi_eq_4_9);

figure;
plot(m_values, error, 'x');
grid on;

