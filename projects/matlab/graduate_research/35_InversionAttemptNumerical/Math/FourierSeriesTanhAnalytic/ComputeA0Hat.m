function a0_hat = ComputeA0Hat( ...
    gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns, big_i_a0_vector, omega)

outer_sum = 0;

for m = 1:number_partial_sum_terms_ns
    
    alpha = alpha_coefs(m);
    
    inner_sum = 0;
    
    for k = 0:(m-1)
        a0_integral_big_i = big_i_a0_vector(k+1);
        binomial_coef = nchoosek(2*m-1, 2*k);
        gamma = gamma11_layer0^(2*k)*gamma10_layer0^(2*m-1-2*k);
        inner_sum = inner_sum + a0_integral_big_i*binomial_coef*gamma;
    end
    
    outer_sum = outer_sum + alpha*inner_sum;
    
end

a0_hat = (omega/pi)*gamma11_layer1*outer_sum;

end
