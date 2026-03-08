function integral = ComputeCshrNumerical( ...
    lower_bound, upper_bound, dxi, j, a)

xi = lower_bound:dxi:upper_bound;
integrand = xi.^j .* csch(a*xi);
integral = trapz(xi, integrand);

end