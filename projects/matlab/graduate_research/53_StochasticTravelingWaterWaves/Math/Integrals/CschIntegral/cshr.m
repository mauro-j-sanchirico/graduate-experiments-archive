function y = cshr(j_index, rho)
y = cshi(j_index, rho) - cshi(j_index, 100*eps);
end
