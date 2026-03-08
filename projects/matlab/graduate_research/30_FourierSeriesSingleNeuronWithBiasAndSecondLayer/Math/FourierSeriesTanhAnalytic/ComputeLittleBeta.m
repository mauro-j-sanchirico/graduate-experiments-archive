function little_beta = ComputeLittleBeta( ...
    j_index, k_index, gamma10_layer0, gamma11_layer0, gamma11_layer1, alpha_coefs)

big_g = ComputeBigG( ...
    j_index, k_index, gamma10_layer0, gamma11_layer0, gamma11_layer1);
m_index = (j_index + 1)/2;
little_beta = alpha_coefs(m_index)*big_g*nchoosek(j_index, k_index);

end
