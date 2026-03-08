function phi_integral = ComputePhiTanhDefIntegral(p, r)

dx = 0.001;
x = dx:dx:r;
a = pi/2;
integrand = csch(a*x).*x.^p;
phi_integral = trapz(x, integrand);

end


