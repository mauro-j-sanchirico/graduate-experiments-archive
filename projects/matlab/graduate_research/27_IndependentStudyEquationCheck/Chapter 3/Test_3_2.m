clc; clear; close all;

u = -1:0.01:1;

lhs = tanh(u);

rhs = 0;
M = 20;

for m = 1:M
    numerator = 2^(2*m)*(2^(2*m) - 1)*bernoulli(2*m);
    denominator = factorial(2*m);
    coef = numerator/denominator;
    rhs = rhs + coef*u.^(2*m - 1);
end

figure;
plot(u, lhs);
hold on;
plot(u, rhs);

error = abs(lhs - rhs);

figure;
plot(u, error);
