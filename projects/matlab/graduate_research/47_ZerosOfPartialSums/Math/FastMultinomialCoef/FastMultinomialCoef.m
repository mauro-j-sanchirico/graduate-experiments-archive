function c = FastMultinomialCoef(mc_table, m_num_terms, n_exponent, k)
multi_index_key = GetMultiIndexKey(k);
c = mc_table{m_num_terms}{n_exponent}(multi_index_key);
end