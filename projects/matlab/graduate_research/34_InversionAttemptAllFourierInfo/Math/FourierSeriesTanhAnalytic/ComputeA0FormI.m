function a0 = ComputeA0FormI( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns, omega)

outer_sum = 0;

k_start = 0;
k_end = number_partial_sum_terms_ns - 1;

for m = 1:number_partial_sum_terms_ns
    
    alpha = alpha_coefs(m);
    
    inner_sum = 0;
    
    for k = 0:(m-1)
        a0_integral_big_i = ComputeBigIA0Integral(k, omega);
        binomial_coef = nchoosek(2*m-1, 2*k);
        gamma = gamma11_layer0^(2*k)*gamma10_layer0^(2*m-1-2*k);
        inner_sum = inner_sum + a0_integral_big_i*binomial_coef*gamma;
    end
    
    outer_sum = outer_sum + alpha*inner_sum;
    
end

a0 = 2*gamma10_layer1 + (omega/pi)*gamma11_layer1*outer_sum;

end
