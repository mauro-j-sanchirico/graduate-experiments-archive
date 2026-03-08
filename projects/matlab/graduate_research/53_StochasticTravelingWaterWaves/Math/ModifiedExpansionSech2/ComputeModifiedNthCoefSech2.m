function coefs = ComputeModifiedNthCoefSech2(n_list, big_n, r)

coefs = zeros(size(n_list));

q = 2*big_n + 2;
rho = factorial(q)^(1/q);

for idx = 1:length(n_list)

    n = n_list(idx);
    
    if mod(n, 2) == 0
        modification = ComputeCshrNumerical(n+1, rho/r, 0.0001);
        coefs(idx) = (-1)^(n/2) * modification / factorial(n);
    end
    
end

end
