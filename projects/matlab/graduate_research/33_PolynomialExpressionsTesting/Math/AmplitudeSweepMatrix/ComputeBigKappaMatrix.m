function big_kappa = ComputeBigKappaMatrix( ...
    number_partial_sum_terms_ns, number_interrogation_points_big_p, ...
    big_i_bn_matrix, alpha_coefs, amplitude_sweep_vector_big_a)

% Rows are indexed by p, columns are indexed by the i = 1...P=M(M+1)
% M = number of terms in the partial sum
big_kappa = zeros( ...
    number_interrogation_points_big_p, number_interrogation_points_big_p);

n_fourier = 1;

for p = 1:number_interrogation_points_big_p
    big_a = amplitude_sweep_vector_big_a(p);
    idx = 1;
    for m = 1:number_partial_sum_terms_ns
        alpha = alpha_coefs(m);
        for k = 0:(2*m - 1)
            % Same as ComputeBigIBnIntegral(k, n_fourier, omega);
            bn_integral_big_i = big_i_bn_matrix(n_fourier, k+1);
            binomial_coef = nchoosek(2*m-1, k);
            big_kappa(p, idx) = ...
                (1/pi)*bn_integral_big_i*binomial_coef*alpha*big_a^k;
            idx = idx + 1;
        end
    end
end


end

