function a0 = ComputeA0( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns, omega)

a0_sum = 0;

k_start = 0;
k_end = number_partial_sum_terms_ns - 1;

for k_index = k_start:k_end
    a0_integral_big_i = ComputeBigIA0Integral(k_index, omega);
    big_beta = ComputeBigBeta( ...
        number_partial_sum_terms_ns, 2*k_index, ...
        gamma10_layer0, gamma11_layer0, gamma11_layer1, alpha_coefs);
    term = a0_integral_big_i*big_beta;
    a0_sum = a0_sum + term;
end

a0 = 2*gamma10_layer1 + (omega/pi)*a0_sum;

end

