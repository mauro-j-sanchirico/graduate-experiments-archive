clc; clear; close all;

xi0 = 1;
xi1 = 2;
dxi = 0.0001;

j = 4;

% parameters for secant
a = pi/2; b = 0;
fprintf('Secant integrals (general, numerical general, numerical direct)');
ComputeGeneralizedSecantIntegral(j, a, b, xi0, xi1)
ComputeGeneralizedSecantIntegralNumerical(j, a, b, xi0, xi1, dxi)
ComputeSchrNumerical(xi0, xi1, dxi, j, a)

% parameters for cosecant
a = pi/2; b = pi/2;
fprintf('Cosecant integrals (general, numerical general, numerical direct)');
1i*ComputeGeneralizedSecantIntegral(j, a, b, xi0, xi1)
1i*ComputeGeneralizedSecantIntegralNumerical(j, a, b, xi0, xi1, dxi)
ComputeCshrNumerical(xi0, xi1, dxi, j, a)
