function integral = ComputeSechLinearArgIntegralNumerically( ...
    a, b, j, x0, x1, dx)

x = x0:dx:x1;
integrand = x.^j .* sech(a*x + b);
integral = trapz(x, integrand);

end

