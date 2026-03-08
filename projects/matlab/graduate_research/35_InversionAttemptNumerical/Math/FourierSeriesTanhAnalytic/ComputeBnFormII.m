function bn = ComputeBnFormII( ...
    gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns, n_fourier, omega)

outer_sum = 0;

k_start = 0;
k_end = 2*number_partial_sum_terms_ns - 1;

for k = k_start:k_end
    
    bn_integral_big_i = ComputeBigIBnIntegral(k, n_fourier, omega);
    
    m_start = floor(k/2) + 1;
    
    inner_sum = 0;
    
    for m = m_start:number_partial_sum_terms_ns
        alpha = alpha_coefs(m);
        binomial_coef = nchoosek(2*m-1, k);
        gamma = gamma11_layer0^k*gamma10_layer0^(2*m-1-k);
        inner_sum = inner_sum + alpha*binomial_coef*gamma;
    end

    outer_sum = outer_sum + bn_integral_big_i*inner_sum;
end

bn = gamma11_layer1*(omega/pi)*outer_sum;

end

