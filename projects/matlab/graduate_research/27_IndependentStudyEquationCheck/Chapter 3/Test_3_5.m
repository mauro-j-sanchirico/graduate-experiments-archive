clc; clear; close all;

n_array = 1:10;
mid_term = zeros(size(n_array));
rhs_term = zeros(size(n_array));
gamma = 2;

for idx = 1:length(n_array)
    
    n = n_array(idx);

    % Middle term
    psi = 0:0.01:2*pi;

    integrand = tanh(gamma*sin(psi)).*sin(n*psi);
    integral = trapz(psi, integrand);
    mid_term(idx) = (1/pi)*integral;

    % Right hand term
    psi = 0:0.01:pi;
    integrand = tanh(gamma*sin(psi)).*sin(n*psi);
    integral = trapz(psi, integrand);
    rhs_term(idx) = (2/pi)*integral;
    
end

error = abs(rhs_term - mid_term);

figure;
stem(rhs_term);
hold on;
stem(mid_term);

figure;
stem(error)
