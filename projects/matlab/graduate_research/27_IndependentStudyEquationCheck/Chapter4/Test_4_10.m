clc; clear; close all;

v = -1:0.01:1;
xi = 0.001:0.001:1000;
M = 10;

lhs = tanh(v);

sum = zeros(size(v));

for m = 1:M
    
    integrand = csch((pi/2)*xi).*xi.^(2*m-1);
    integral = trapz(xi, integrand);
    
    numerator = integral*(-1).^(m-1)*v.^(2*m-1);
    denominator = factorial(2*m - 1);
    
    term = numerator/denominator;
    
    sum = sum + term;
    
end

rhs = sum;

error = abs(lhs - rhs);

figure;
plot(v, lhs);
hold on;
plot(v, rhs);

figure;
plot(v, error);
