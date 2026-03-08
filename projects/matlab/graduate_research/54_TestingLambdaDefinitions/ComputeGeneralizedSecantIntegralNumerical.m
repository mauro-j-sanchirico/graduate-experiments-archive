function integral = ComputeGeneralizedSecantIntegralNumerical( ...
    j, a, b, xi0, xi1, dxi)

xi = xi0:dxi:xi1;
integrand = xi.^j .* sec(1i*a*xi + b);
integral = trapz(xi, integrand);

end