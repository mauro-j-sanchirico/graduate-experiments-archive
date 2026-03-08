clc; clear; close all;

gamma = 1;
psi = 0:0.1:2*pi;
M = 20;

lhs = tanh(gamma*sin(psi));

rhs = 0;

for m = 1:M
    inner_sum = 0;
    for k = 0:(m-1)
        numerator = ...
            (-1).^(m+k-1) ...
           *4*(2^(2*m)-1) ...
           *bernoulli(2*m)...
           *nchoosek(2*m-1, k) ...
           *gamma.^(2*m-1);
       
        denominator = factorial(2*m);
        
        coef = numerator/denominator;
        
        sin_term = sin((2*m - 2*k - 1).*psi);
        
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