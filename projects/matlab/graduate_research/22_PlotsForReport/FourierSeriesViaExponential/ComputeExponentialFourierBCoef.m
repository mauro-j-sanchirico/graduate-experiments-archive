function b = ComputeExponentialFourierBCoef( ...
    n, gamma, M, L, mu_table, q_table)

b = 2/(2*n - 1);

for m_idx = 1:M

    inner_sum = 0;
    
    for l_idx = 0:L
        q = LookupQFunction(m_idx, l_idx, q_table);
        mu = LookupMuFunction(n, l_idx, mu_table);
        inner_sum = inner_sum + q*mu*gamma.^l_idx;
    end
    
    b = b + inner_sum;
    
end

end

