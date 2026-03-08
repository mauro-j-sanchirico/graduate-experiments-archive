function big_alpha = ComputeBigAlpha(j_index, k_index, alpha_coefs)

m_index = (j_index + 1)/2;

big_alpha = nchoosek(j_index, k_index).*alpha_coefs(m_index);

end

