function an = ComputeAnFormI( ...
    gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns, n_fourier, omega)

outer_sum = 0;

for m = 1:number_partial_sum_terms_ns
    
    alpha = alpha_coefs(m);
    
    inner_sum = 0;
    
    for k = 0:(2*m - 1)
        an_integral_big_i = ComputeBigIAnIntegral(k, n_fourier, omega);
        binomial_coef = nchoosek(2*m-1, k);
        gamma = gamma11_layer0^k*gamma10_layer0^(2*m-1-k);
        inner_sum = inner_sum + an_integral_big_i*binomial_coef*gamma;
    end

    outer_sum = outer_sum + alpha*inner_sum;
end

an = gamma11_layer1*(omega/pi)*outer_sum;

end
