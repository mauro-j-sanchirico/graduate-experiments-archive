function mu_sine_even_matrix = BuildMuSineEvenMatrix(K)

mu_sine_even_matrix = zeros(K,K);

for j = 0:K
    for k = 0:K
        % mu_sine_even_table(k, j) in C++
        mu_sine_even_matrix(j+1, k+1) = ComputeMuSineEven(j, k);
    end
end

end
