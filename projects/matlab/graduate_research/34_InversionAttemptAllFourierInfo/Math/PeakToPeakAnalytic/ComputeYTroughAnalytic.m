function y_trough = ComputeYTroughAnalytic( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns)

outer_sum = 0;

for m = 1:number_partial_sum_terms_ns
    
    alpha = alpha_coefs(m);
    
    inner_sum = 0;
    
    for k = 0:(2*m - 1)
        sign_term = (-1)^k;
        binomial_coef = nchoosek(2*m-1, k);
        gamma = gamma11_layer0^k*gamma10_layer0^(2*m-1-k);
        inner_sum = inner_sum + binomial_coef*gamma*sign_term;
    end

    outer_sum = outer_sum + alpha*inner_sum;
end

y_trough = gamma10_layer1 + gamma11_layer1*outer_sum;

