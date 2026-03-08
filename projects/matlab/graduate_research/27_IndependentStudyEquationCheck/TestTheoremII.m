clc; clear; close all;

psi = 0.001:0.001:(pi-0.001);
gamma = 0.8;
N = 5;
L = 150;
M = 4;

lhs = tanh(gamma*sin(psi));

sum = 0;
for n = 1:N
    b = ComputeB(n, gamma, L, M);
    sum = sum + b*sin(n*psi);
end

rhs = sum;

figure;
plot(lhs)
hold on
plot(rhs)

error = abs(lhs - rhs);

figure;
plot(error);

function b = ComputeB(n, gamma, L, M)
    if mod(n, 2) == 0
        b = 0;
    else
        k = (n + 1)/2;
        sum = 2/(2*k-1);
        for ll = 0:L
            lambda = ComputeLambda(k,ll, M);
            sum = sum + lambda*gamma.^ll;
        end
        b = (2/pi)*sum;
    end
end

function lambda = ComputeLambda(k, ll, M)
    sum = 0;
    for m = 1:M
        q = ComputeQ(m, ll);
        sum = sum + q;
    end
    mu = ComputeMuNumerical(k, ll);
    lambda = mu*sum;
end

function q = ComputeQ(m, ll)
    q = (-1)^(m+ll)*2^(ll+1)*m^ll/factorial(ll);
end

function mu = ComputeMuNumerical(k, ll)
    psi = 0.001:0.001:(pi-0.001);
    integrand = sin((2*k-1)*psi).*sin(psi).^ll;
    mu = trapz(psi, integrand);
end