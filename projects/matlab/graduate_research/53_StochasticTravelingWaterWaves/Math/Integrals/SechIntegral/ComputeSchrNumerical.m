function y = ComputeSchrNumerical(j_index, rho, dxi)
a = pi/2;
xi = 0:dxi:rho;
integrand = xi.^j_index.*sech(a*xi);
y = trapz(xi, integrand);
end
