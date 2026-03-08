function mu = ComputeMuFunction(n, L, binomial_table)

% If l is even
if mod(L,2) == 0
    LE = L/2;
    mu = 2^(1-L)/(2*n-1)*LookupBinomialCoef(L, LE, binomial_table);
    for k=0:LE-1
        term1 = (-1)^(LE-k)*2^(2-L);
        term2 = (2*n-1)/(4*n^2-4*n+1-L^2+4*L*k-4*k^2);
        binomial_coef = LookupBinomialCoef(L, k, binomial_table);
        mu = mu + term1*term2*binomial_coef;
    end
else
    mu = 0;
    LO = (L - 1)/2;
    for k = 0:LO
        nu = ComputeNuFunction(n, k, LO);
        binomial_coef = LookupBinomialCoef(L, k, binomial_table);
        mu = mu + 2^(1-L)*(-1)^(LO+k)*binomial_coef*nu; 
    end
end

end

