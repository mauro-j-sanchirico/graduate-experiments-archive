function poly_coefs = GetPolynomialCoefsTanhModifiedExpansion( ...
    number_terms_big_m, epsilon, dxi, max_v, ...
    rho_table, numerical_integral_flag)

alpha_coefs = ComputeAlphaExpansionCoefs( ...
    number_terms_big_m, epsilon, dxi, max_v, ...
    rho_table, numerical_integral_flag);

poly_coefs = zeros(1, 2*number_terms_big_m);

alpha_coefs = fliplr(alpha_coefs);

for poly_index = 1:2*number_terms_big_m
    index_is_odd = mod(poly_index, 2);
    if index_is_odd
        taylor_index = (poly_index+1)/2;
        poly_coefs(poly_index) = alpha_coefs(taylor_index);
    end
end

end

