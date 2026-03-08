function big_beta = ComputeBigBeta( ...
    number_partial_sum_terms_ns, k_index, ...
    gamma10_layer0, gamma11_layer0, gamma11_layer1, alpha_coefs)

sum = 0;

m_start = floor(k_index/2) + 1;
m_end = number_partial_sum_terms_ns;

for m = m_start:m_end
    
    j = 2*m-1;
    
    little_beta = ComputeLittleBeta( ...
        j, k_index, gamma10_layer0, gamma11_layer0, ...
        gamma11_layer1, alpha_coefs);
    
    sum = sum + little_beta;
    
end

big_beta = sum;

end
