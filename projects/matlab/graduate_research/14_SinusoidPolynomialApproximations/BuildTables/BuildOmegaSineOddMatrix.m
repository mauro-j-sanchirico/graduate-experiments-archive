function omega_sine_odd_matrix = BuildOmegaSineOddMatrix(K, omega)

omega_sine_odd_matrix = zeros(K, K);

% Build a lower triangular matrix where each column is an odd power of k
for j = 0:K
    for k = 0:K
        if k <= j
            % omega_sine_odd_matrix(j, k) in C++
            omega_sine_odd_matrix(j+1, k+1) = omega.^(2*k+1);
        end
    end
end

end
