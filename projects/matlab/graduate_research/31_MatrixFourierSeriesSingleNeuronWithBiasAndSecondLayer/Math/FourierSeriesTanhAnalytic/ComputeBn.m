function bn = ComputeBn( ...
    gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns, n_fourier, omega)

bn_sum = 0;

k_start = 0;
k_end = 2*number_partial_sum_terms_ns - 1;

for k_index = k_start:k_end
    bn_integral_big_i = ComputeBigIBnIntegral(k_index, n_fourier, omega);
    big_beta = ComputeBigBeta( ...
        number_partial_sum_terms_ns, k_index, ...
        gamma10_layer0, gamma11_layer0, gamma11_layer1, alpha_coefs);
    term = bn_integral_big_i*big_beta;
    bn_sum = bn_sum + term;
end

bn = (omega/pi)*bn_sum;

end

