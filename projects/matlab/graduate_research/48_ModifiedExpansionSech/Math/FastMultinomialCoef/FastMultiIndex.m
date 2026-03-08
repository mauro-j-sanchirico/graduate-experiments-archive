function k = FastMultiIndex(mi_table, m_num_terms, n_exponent, k_idx)
k = mi_table{m_num_terms}{n_exponent}(k_idx, :);
end
