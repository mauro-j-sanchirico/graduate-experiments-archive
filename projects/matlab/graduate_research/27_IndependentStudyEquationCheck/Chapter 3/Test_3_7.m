clc; clear; close all;

gamma = 1.5;
psi = 0.1:0.1:(pi-0.1);
N = 10;
M = 30;

b = zeros(size(1:N));

lhs = tanh(gamma*sin(psi));

% Compute the fourier coefficients
for n = 1:N
    inner_sum = 0;
    for m = 1:M
        inner_sum = inner_sum + (-1)^m*exp(-2*m*gamma*sin(psi));
    end
    integrand = (1 + 2*inner_sum).*sin(n*psi);
    integral = trapz(psi, integrand);
    b(n) = (2/pi)*integral;
end

% Sum the fourier series
rhs = 0;

for n = 1:N
   rhs = rhs + b(n)*sin(n*psi);
end

figure;
plot(psi, lhs);
hold on;
plot(psi, rhs);

error = abs(lhs - rhs);

figure;
plot(psi, error);
