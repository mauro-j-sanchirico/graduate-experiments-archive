clc; clear; close all;

gamma = 1;
psi = 0:0.1:2*pi;
M = 25;
N = 5;

b = zeros(size(1:N));

lhs = tanh(gamma*sin(psi));
rhs = 0;

for n = 1:N
    % Even b indexs hold 0's
    if mod(n, 2) == 0
        b(n) = 0;
    else
        sum = 0;
        k = (n + 1)/2;
        for m = k:M
            numerator = ...
                (-1).^(2*m-k-1)*4*(2^(2*m)-1) ...
               *nchoosek(2*m-1, m-k) ...
               *bernoulli(2*m) ...
               *gamma.^(2*m-1);
            denominator = factorial(2*m);
            coef = numerator / denominator;
            sum = sum + coef;
        end
        b(n) = sum;
    end
end

for n = 1:n
    rhs = rhs + b(n)*sin(n*psi);
end

figure;
plot(psi, lhs);
hold on;
plot(psi, rhs);

error = abs(lhs - rhs);

figure;
plot(psi, error);