function phi_sine_even_matrix = BuildPhiSineEvenMatrix(K, phi)

phi_sine_even_matrix = zeros(K,K);

for j = 0:K
    for k = 0:K
        % phi_sine_even_table(j, k) in C++
        phi_sine_even_matrix(j+1, k+1) = ComputePhiSineEven(j, k, phi);
    end
end

end
