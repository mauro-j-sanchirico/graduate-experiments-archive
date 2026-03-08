function big_kappa = ComputeBigKappaMatrix( ...
    number_partial_sum_terms_ns, number_interrogation_points_big_p, ...
    big_i_matrix, alpha_coefs, amplitude_sweep_vector_big_a, ...
    number_fourier_coefs_n)

big_kappa = [];

for n = 1:number_fourier_coefs_n

    % Rows are indexed by p, columns are indexed by the i = 1...P=M(M+1)
    % M = number of terms in the partial sum
    big_kappa_n = zeros( ...
        number_interrogation_points_big_p, ... 
        number_interrogation_points_big_p);

    for p = 1:number_interrogation_points_big_p
        big_a = amplitude_sweep_vector_big_a(p);
        idx = 1;
        for m = 1:number_partial_sum_terms_ns
            alpha = alpha_coefs(m);
            for k = 0:(2*m - 1)
                % Same as ComputeBigIBnIntegral(k, n_fourier, omega);
                integral_big_i = big_i_matrix(n, k+1);
                binomial_coef = nchoosek(2*m-1, k);
                big_kappa_n(p, idx) = ...
                    (1/pi)*integral_big_i*binomial_coef*alpha*big_a^k;
                idx = idx + 1;
            end
        end
    end
    
    big_kappa = [big_kappa; big_kappa_n];

end

