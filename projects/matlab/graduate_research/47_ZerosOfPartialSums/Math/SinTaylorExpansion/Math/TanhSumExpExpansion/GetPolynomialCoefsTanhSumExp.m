function poly_coefs = GetPolynomialCoefsTanhSumExp( ...
    m_index_max, l_index_max)

sum_exp_coefs = ComputeTanhSumExpCoefs(m_index_max, l_index_max);
sum_exp_coefs = fliplr(sum_exp_coefs);
poly_coefs = 2*sum_exp_coefs;
poly_coefs(end) = poly_coefs(end) + 1;

end
