function omega_sine_even_matrix = BuildOmegaSineEvenMatrix(K, omega)

omega_sine_even_matrix = zeros(K, K);

% Build a lower triangular matrix where each column is an even power of k
for j = 0:K
    for k = 0:K
        if k <= j
            % omega_sine_odd_vector(j, k) in C++
            omega_sine_even_matrix(j+1, k+1) = omega.^(2*k);
        end
    end
end

end
