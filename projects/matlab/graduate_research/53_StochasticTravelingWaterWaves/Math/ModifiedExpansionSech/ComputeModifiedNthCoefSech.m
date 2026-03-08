function coefs = ComputeModifiedNthCoefSech(n_list, big_n, r)

coefs = zeros(size(n_list));

q = 2*big_n + 2;
rho = factorial(q)^(1/q);

for idx = 1:length(n_list)

    n = n_list(idx);
    
    if mod(n, 2) == 0
        modification = ComputeSchrNumerical(n, rho/r, 0.00001);
        coefs(idx) = (-1)^(n/2) * modification / factorial(n);
    end
    
end

end
