function y = ComputeCshrNumerical(j_index, rho, dxi)
a = pi/2;
xi = eps:dxi:rho;
integrand = xi.^j_index.*csch(a*xi);
y = trapz(xi, integrand);
end
