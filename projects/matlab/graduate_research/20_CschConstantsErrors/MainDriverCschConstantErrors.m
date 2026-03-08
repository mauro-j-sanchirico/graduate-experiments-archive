%% MainDriverCschConstantErrors
%% Here we aim to answer: how far must we integrate the master integrand?

clc; clear; close all;

p = 1;
r = 0.1:0.1:10;

figure;
for p_idx = 1:length(p)
    mu = zeros(1, length(r));
    mu_hat = zeros(1, length(r));
    for r_idx = 1:length(r)
        mu(r_idx) = ComputeMuTanhDefIntegral0InfAnalytical(p(p_idx));
        mu_hat(r_idx) = ComputeMuTanhDefIntegral(p(p_idx), r(r_idx));
        epsilon = mu - mu_hat;
    end
    semilogy(r, abs(epsilon));
    hold on;
end

grid on;

function mu_integral = ComputeMuTanhDefIntegral(p, r)
dx = 0.0001;
x = dx:dx:r;
a = pi/2;
integrand = csch(a*x).*x.^p;
mu_integral = trapz(x, integrand);
end

function mu_integral = ComputeMuTanhDefIntegral0InfAnalytical(p)
beta = p + 1;
a = pi/2;
numerator = (2^vpa(beta) - vpa(1))*gamma(vpa(beta))*zeta(vpa(beta));
denominator = 2^(vpa(beta) - vpa(1))*a^vpa(beta);
mu_integral = numerator / denominator;
end