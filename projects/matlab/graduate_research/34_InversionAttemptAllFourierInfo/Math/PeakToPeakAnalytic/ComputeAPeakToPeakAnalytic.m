function a_peak_to_peak = ComputeAPeakToPeakAnalytic( ...
    gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns)

outer_sum = 0;

for m = 1:number_partial_sum_terms_ns
    
    alpha = alpha_coefs(m);
    
    inner_sum = 0;
    
    for k = 0:(m-1)
        binomial_coef = nchoosek(2*m-1, 2*k+1);
        gamma = gamma11_layer0^(2*k+1)*gamma10_layer0^(2*m-2-2*k);
        inner_sum = inner_sum + binomial_coef*gamma;
    end

    outer_sum = outer_sum + alpha*inner_sum;
end

a_peak_to_peak = 2*gamma11_layer1*outer_sum;

end

