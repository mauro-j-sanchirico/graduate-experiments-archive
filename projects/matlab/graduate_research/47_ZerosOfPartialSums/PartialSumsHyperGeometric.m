clc; clear; close all;

x = 0:0.01:20;

M = 20;

% Compute the partial sum
cosM = zeros(size(x));
for m = 0:M
    term = (-1)^m * x.^(2*m+1) ./ factorial(2*m+1);
    cosM = cosM + term;
end

% Compute the partial sum from the hypergeometric function
fp =  x.^(2*M+3) ./ factorial(2*M + 3);
fh = hypergeom(1, [M+2, M + 5/2], -x.^2./4);
cosM_formula = (-1)^M*fp.*fh + sin(x);

figure;
plot(x, cosM, 'b', 'linewidth', 6);
hold on;
plot(x, cosM_formula, 'g');

% Analyze the parts of the partial sum
x = 0:0.1:100;
fh = hypergeom(1, [M+2, M + 5/2], -x.^2./4);
fp = x.^(2*M+3) ./ factorial(2*M + 3);

figure;
semilogy(x, fh);
hold on
semilogy(x, fp);