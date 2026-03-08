function y = ComputePolynomialNetworkOutputFormII( ...
    x_hat_normalized_input, alpha_coefs, ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    number_partial_sum_terms_ns)

sum = 0;

for k = 0:2*number_partial_sum_terms_ns-1
    m_start = (floor(k/2) + 1);
    for m = m_start:number_partial_sum_terms_ns
        alpha = alpha_coefs(m);
        gamma = ...
            gamma11_layer0.^k*gamma10_layer0.^(2*m - 1 - k);
        binomial_coef = nchoosek(2*m - 1, k);
        term = alpha*binomial_coef*gamma*x_hat_normalized_input.^k;
        sum = sum + term;
    end
end

y = gamma10_layer1 + gamma11_layer1*sum;
