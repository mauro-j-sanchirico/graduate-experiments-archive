function Mu_integral = ...
    ComputeMuDefIntegral0InfNumerical(dxi, approx_inf, n)

xi = dxi:dxi:approx_inf;
mu_integrand = ComputeMuFunction(xi, n);
Mu_integral = trapz(xi, mu_integrand);

%semilogy(xi, mu_integrand);
%hold on;

end
