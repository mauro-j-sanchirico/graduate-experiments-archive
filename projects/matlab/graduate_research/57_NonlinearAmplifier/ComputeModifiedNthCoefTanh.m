function coefs = ComputeModifiedNthCoefTanh(n_list, big_n, r)

coefs = zeros(size(n_list));

q = 2*big_n + 3;
rho = factorial(q)^(1/q);

for idx = 1:length(n_list)

    n = n_list(idx);

    if mod(n, 2) == 1
        modification = ComputeCshrNumerical(n, rho/r, 0.00001);
        coefs(idx) = (-1)^((n+1)/2 - 1) * modification / factorial(n);
    end

end

end
