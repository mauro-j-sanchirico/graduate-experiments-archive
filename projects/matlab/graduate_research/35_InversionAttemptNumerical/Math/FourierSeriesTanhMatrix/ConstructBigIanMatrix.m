function big_i_an_matrix = ConstructBigIanMatrix( ...
    number_fourier_coefs_n, number_partial_sum_terms_ns, omega)

n = 1:number_fourier_coefs_n;
k = 0:(2*number_partial_sum_terms_ns - 1);

big_i_an_matrix = zeros( ...
    number_fourier_coefs_n, 2*number_partial_sum_terms_ns);

for n_idx = 1:length(n)
    for k_idx = 1:length(k)
        big_i_an_matrix(n_idx, k_idx) = ...
            ComputeBigIAnIntegral(k(k_idx), n(n_idx), omega);
    end
end

end
