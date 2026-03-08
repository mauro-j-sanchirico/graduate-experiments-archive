function mu_sine_odd_matrix = BuildMuSineOddMatrix(K)

mu_sine_odd_matrix = zeros(K,K);

for j = 0:K
    for k = 0:K
        % mu_sine_odd_table(k, j) in C++
        mu_sine_odd_matrix(j+1, k+1) = ComputeMuSineOdd(j, k);
    end
end

end

