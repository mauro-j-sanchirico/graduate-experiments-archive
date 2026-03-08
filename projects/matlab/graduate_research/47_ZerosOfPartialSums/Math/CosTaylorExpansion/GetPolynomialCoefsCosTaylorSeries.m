function poly_coefs = ...
    GetPolynomialCoefsCosTaylorSeries(number_terms_big_m)

taylor_coefs = ComputeCosTaylorCoefs(number_terms_big_m);
poly_coefs = zeros(1, 2*number_terms_big_m);

taylor_coefs = fliplr(taylor_coefs);

for poly_index = 1:2*number_terms_big_m
    index_is_even = ~mod(poly_index, 2);
    if index_is_even
        taylor_index = poly_index/2;
        poly_coefs(poly_index) = taylor_coefs(taylor_index);
    end
end

end
