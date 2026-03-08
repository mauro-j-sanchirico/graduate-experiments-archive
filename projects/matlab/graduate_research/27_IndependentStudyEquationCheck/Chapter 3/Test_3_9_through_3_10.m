clc; clear; close all;

gamma = 2;
psi = 0.01:0.01:(pi-0.01);
N = 10;
M = 4;
L = 150;

b = zeros(size(1:N));

lhs = tanh(gamma*sin(psi));

% Compute the fourier coefficients
for n = 1:N
    if mod(n,2) == 0
        b(n) = 0;
    else
        k = (n + 1)/2;
        double_sum = 0;
        for m = 1:M
            inner_sum = 0;
            for ll = 0:L
                q = (-1)^(m+ll)*2^(ll+1)*m^ll/factorial(ll);
                gamma_power = gamma.^(ll);
                integrand = sin((2*k-1)*psi).*(sin(psi).^ll);
                integral = trapz(psi, integrand);
                inner_sum = inner_sum + q*gamma_power*integral;
            end
            double_sum = double_sum + inner_sum;
        end
        b(n) = (2/pi)*(2/(2*k - 1) + double_sum);
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
