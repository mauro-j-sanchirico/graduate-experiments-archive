%% Quick Check Script for Alternate Forms of Identities

clc; clear; close all;

%% Define some test parameters

% Parameters
a = pi/2;
j = 2;

% Bounds of integration
dx = 0.0001;
x0 = 1;
x1 = 6;

%% Compute the numerical integrals

x = x0:dx:x1;

integrand = x.^j .* sech(a*x);
fprintf('Sech numerical:')
integral = trapz(x, integrand)

integrand = x.^j .* csch(a*x);
fprintf('Csch numerical:')
integral = trapz(x, integrand)

%% Compute the analytical integrals

% Sech Form I
fprintf('Sech Form I:')
SechAntiDerivFormI(a, j, x1) - SechAntiDerivFormI(a, j, x0)

% Sech Form II
fprintf('Sech Form II:')
SechAntiDerivFormII(a, j, x1) - SechAntiDerivFormII(a, j, x0)

% Csch Form I
fprintf('Csch Form I:')
CschAntiDerivFormI(a, j, x1) - CschAntiDerivFormI(a, j, x0)

% Csch Form II
fprintf('Csch Form II:')
CschAntiDerivFormII(a, j, x1) - CschAntiDerivFormII(a, j, x0)

%% Functions

function y = SechAntiDerivFormI(a, j, x)

summation = 0;

for k = 0:j
    term = factorial(j) * x.^(j - k) .* Ti(k+1, exp(-a*x)) ...
        ./ (factorial(j-k) * a^(k+1));
    summation = summation + term;
end

y = -2*summation;

end

function y = SechAntiDerivFormII(a, j, x)

summation = 0;

for k = 0:j
    term = factorial(j) * x.^(j - k) .* Chi(k+1, 1i*exp(-a*x)) ...
        ./ (factorial(j-k) * a^(k+1));
    summation = summation + term;
end

y = 2*1i*summation;

end

function y = CschAntiDerivFormI(a, j, x)

summation = 0;

for k = 0:j
    term = factorial(j) * x.^(j - k) .* Chi(k+1, exp(-a*x)) ...
        ./ (factorial(j-k) * a^(k+1));
    summation = summation + term;
end

y = -2*summation;

end

function y = CschAntiDerivFormII(a, j, x)

summation = 0;

for k = 0:j
    term = factorial(j) * x.^(j - k) .* Ti(k+1, -1i*exp(-a*x)) ...
        ./ (factorial(j-k) * a^(k+1));
    summation = summation + term;
end

y = -2*1i*summation;

end

