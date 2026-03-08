clc; clear; close all;

gamma = 3;
psi = 0.01:0.01:(pi-0.01);
N = 10;
M = 30;

b = zeros(size(1:N));

lhs = tanh(gamma*sin(psi));

% Compute the fourier coefficients
for n = 1:N
    if mod(n,2) == 0
        b(n) = 0;
    else
        k = (n + 1)/2;
        inner_sum = 0;
        for m = 1:M
            integrand = sin((2*k-1)*psi).*exp(-2*m*gamma*sin(psi));
            integral = trapz(psi, integrand);
            term = (-1)^m*integral;
            inner_sum = inner_sum + term;
        end
        b(n) = (2/pi)*(2/(2*k - 1) + 2*inner_sum);
    end
end

% Sum the fourier series
rhs = zeros(size(psi));

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
