function poly_coefs = ...
    GetPolynomialCoefsTanhTaylorSeries(number_terms_big_m)

taylor_coefs = ComputeTanhTaylorCoefs(number_terms_big_m);
poly_coefs = zeros(1, 2*number_terms_big_m);

taylor_coefs = fliplr(taylor_coefs);

for poly_index = 1:2*number_terms_big_m
    index_is_odd = mod(poly_index, 2);
    if index_is_odd
        taylor_index = (poly_index+1)/2;
        poly_coefs(poly_index) = taylor_coefs(taylor_index);
    end
end

end
