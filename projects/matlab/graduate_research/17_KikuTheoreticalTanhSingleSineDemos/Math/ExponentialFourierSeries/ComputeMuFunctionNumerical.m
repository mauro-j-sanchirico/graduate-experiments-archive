function mu = ComputeMuFunctionNumerical(n, L)
x=0:0.00001:pi;
integrand = sin((2*n-1)*x).*(sin(x).^(L));
mu = trapz(x, integrand);
end

