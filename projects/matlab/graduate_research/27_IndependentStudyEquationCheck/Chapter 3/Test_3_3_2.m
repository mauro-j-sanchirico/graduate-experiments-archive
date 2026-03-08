clc; clear; close all;

gamma = 1;
psi = 0:0.1:2*pi;
M = 20;
K = 20;

lhs = tanh(gamma*sin(psi));

rhs = 0;

for k = 1:K
    inner_sum = 0;
    for m = k:M
        numerator = ...
            (-1).^(2*m-k-1) ...
           *4*(2^(2*m)-1) ...
           *nchoosek(2*m-1, m-k) ...
           *bernoulli(2*m) ...
           *gamma.^(2*m-1);
       
       denominator = factorial(2*m);
       
       sin_term = sin((2*k-1)*psi);
       
       coef = numerator / denominator;
       
       inner_sum = inner_sum + coef*sin_term;
    end
    rhs = rhs + inner_sum;
end

figure;
plot(psi, lhs);
hold on;
plot(psi, rhs);

error = abs(lhs - rhs);

figure;
plot(psi, error);