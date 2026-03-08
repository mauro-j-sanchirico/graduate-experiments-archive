clc; clear; close all;

k_values = 1:25;
ll_values = 1:25;

[k_grid, l_grid] = meshgrid(k_values, ll_values);

mu_numerical = zeros(size(k_grid));
mu_analytical = zeros(size(k_grid));

for k = 1:length(k_values)
    for ll = 1:length(ll_values)
        mu_numerical(k, ll) = ComputeMuNumerical(k, ll);
        mu_analytical(k, ll) = ComputeMuAnalytical(k, ll);
    end
end

figure;
stem3(mu_numerical);
hold on;
stem3(mu_analytical);

error = abs(mu_numerical - mu_analytical);

figure;
stem3(error);

function mu = ComputeMuNumerical(k, ll)
    psi = 0.01:0.01:(pi-0.01);
    integrand = sin((2*k-1)*psi).*sin(psi).^ll;
    mu = trapz(psi, integrand);
end

function mu = ComputeMuAnalytical(k, ll)
    sum = 0;
    if mod(ll,2) == 0
        le = ll/2;
        for j = 0:(le-1)
            numerator = ...
                (-1)^(le-j)*2^(2-ll)*(2*k-1)*nchoosek(ll,j);
            denominator = 4*k^2 - 4*k + 1 - ll^2 + 4*ll*j - 4*j^2;
            term = numerator/denominator;
            sum = sum + term;
        end
        mu = (2^(1-ll)/(2*k-1))*nchoosek(ll, le) + sum;
    else
        lo = (ll-1)/2;
        for j = 0:lo
            term = ...
                (-1)^(lo+j)*2^(1-ll)*nchoosek(ll, j)*ComputeNu(j, k, lo);
           sum = sum + term;
        end
        mu = sum;
    end
end

function nu = ComputeNu(j, k, ll)
    if j == ll + k
        nu = -pi/2;
    elseif j == ll - k + 1
        nu = pi/2;
    else
        nu = 0;
    end
end
