function a0 = ComputeA0FormII( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns, omega)

outer_sum = 0;

k_start = 0;
k_end = number_partial_sum_terms_ns - 1;

for k = k_start:k_end
    
    a0_integral_big_i = ComputeBigIA0Integral(k, omega);
    
    m_start = floor(k) + 1;
    
    inner_sum = 0;
    
    for m = m_start:number_partial_sum_terms_ns
        alpha = alpha_coefs(m);
        binomial_coef = nchoosek(2*m-1, 2*k);
        gamma = gamma11_layer0^(2*k)*gamma10_layer0^(2*m-1-2*k);
        inner_sum = inner_sum + alpha*binomial_coef*gamma;
    end
    
    outer_sum = outer_sum + a0_integral_big_i*inner_sum;
    
end

a0 = 2*gamma10_layer1 + (omega/pi)*gamma11_layer1*outer_sum;

end

