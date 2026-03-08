function [x] = EvaluateMultisine(A, omega, phi, bias, t)

x = zeros(size(t)) + bias;

for i = 1:length(A)
    x = x + A(i).*sin(omega(i).*t + phi(i));
end
