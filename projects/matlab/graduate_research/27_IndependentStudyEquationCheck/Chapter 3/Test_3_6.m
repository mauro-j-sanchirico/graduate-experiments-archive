clc; clear; close all;

u = 0.1:0.1:10;
M = 30;

lhs = tanh(u);

sum = 0;

for m = 1:M
    sum = sum + (-1)^m*exp(-2*m*u);
end

rhs = 1 + 2*sum;

error = lhs - rhs;

figure;
plot(u, lhs);
hold on;
plot(u, rhs);

figure;
plot(u, error);