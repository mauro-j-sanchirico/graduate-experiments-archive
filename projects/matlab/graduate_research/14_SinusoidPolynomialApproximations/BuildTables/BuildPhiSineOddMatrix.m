function phi_sine_odd_matrix = BuildPhiSineOddMatrix(K, phi)

phi_sine_odd_matrix = zeros(K,K);

for j = 0:K
    for k = 0:K
        % phi_sine_odd_table(j, k) in C++
        phi_sine_odd_matrix(j+1, k+1) = ComputePhiSineOdd(j, k, phi);
    end
end

end