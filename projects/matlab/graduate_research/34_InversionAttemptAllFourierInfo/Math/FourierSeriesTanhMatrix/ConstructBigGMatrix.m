function big_g_matrix = ConstructBigGMatrix( ...
    gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
    number_partial_sum_terms_ns)

k = 0:(2*number_partial_sum_terms_ns - 1);
m = 1:number_partial_sum_terms_ns;

big_g_matrix = zeros( ...
    2*number_partial_sum_terms_ns, number_partial_sum_terms_ns);

for k_idx = 1:length(k)
    
    k_param = k(k_idx);
    
    m_start = floor(k_param/2) + 1;
    
    for m_idx = 1:length(m)
        if m(m_idx) >= m_start
            j_param = 2*m(m_idx) - 1;
            big_g_matrix(k_idx, m_idx) = ComputeBigG( ...
                j_param, k_param, ...
                gamma10_layer0, gamma11_layer0, gamma11_layer1);
        end
    end

end

end

