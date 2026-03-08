clc; clear; close all;

M = 30;
N = 10;

a = zeros(size(1:N));
b = zeros(size(1:N));

psi = 0.001:0.001:2*pi;

bias = 0.5;
v = bias + sin(psi);

a0 = ComputeFourierA0TheoremIII(psi, v, M);

for n = 1:N
    a(n) = ComputeFourierAnTheoremIII(psi, v, n, M);
    b(n) = ComputeFourierBnTheoremIII(psi, v, n, M);
end

a_sum = 0;
b_sum = 0;

for n = 1:N
    a_sum = a_sum + a(n)*cos(n*psi);
end

for n = 1:N
    b_sum = b_sum + b(n)*sin(n*psi);
end

rhs = 0.5*a0 + a_sum + b_sum;
lhs = tanh(v);

figure;
plot(psi, lhs);
hold on;
plot(psi, rhs);

error = abs(lhs-rhs);

figure;
plot(psi, error);

function a0 = ComputeFourierA0TheoremIII(psi, v, M)

sum = 0;

for m = 1:M
    kappa = ComputeKernelCoefKappaTheoremIII(m);
    integrand = v.^(2*m - 1);
    integral = trapz(psi, integrand);
    term = (-1)^(m-1)*kappa*integral;
    sum = sum + term;
end

a0 = (1/pi)*sum;

end

function an = ComputeFourierAnTheoremIII(psi, v, n, M)

sum = 0;

for m = 1:M
    kappa = ComputeKernelCoefKappaTheoremIII(m);
    integrand = v.^(2*m - 1).*cos(n*psi);
    integral = trapz(psi, integrand);
    term = (-1)^(m-1)*kappa*integral;
    sum = sum + term;
end

an = (1/pi)*sum;

end

function bn = ComputeFourierBnTheoremIII(psi, v, n, M)

sum = 0;

for m = 1:M
    kappa = ComputeKernelCoefKappaTheoremIII(m);
    integrand = v.^(2*m - 1).*sin(n*psi);
    integral = trapz(psi, integrand);
    term = (-1)^(m-1)*kappa*integral;
    sum = sum + term;
end

bn = (1/pi)*sum;

end

function kappa = ComputeKernelCoefKappaTheoremIII(m)

phi = ComputeActivationConstantPhiTheoremIII(m);
kappa = 1/factorial(2*m - 1)*phi;

end

function phi = ComputeActivationConstantPhiTheoremIII(m)

r = 10;
xi = 0.01:0.01:r;
fourier_sin_transform_xi = csch((pi/2)*xi);

integrand = fourier_sin_transform_xi.*xi.^(2*m-1);
integral = trapz(xi, integrand);
phi = integral;

end
