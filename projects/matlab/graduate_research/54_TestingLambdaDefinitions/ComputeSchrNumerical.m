function integral = ComputeSchrNumerical( ...
    lower_bound, upper_bound, dxi, j, a)

xi = lower_bound:dxi:upper_bound;
integrand = xi.^j .* sech(a*xi);
integral = trapz(xi, integrand);

end

