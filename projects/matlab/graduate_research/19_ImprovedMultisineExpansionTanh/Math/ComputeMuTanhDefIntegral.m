function Mu_integral = ComputeMuTanhDefIntegral(p, r)

dx = 0.0001;
x = dx:dx:r;
a = pi/2;
integrand = csch(a*x).*x.^p;
Mu_integral = trapz(x, integrand);

end


