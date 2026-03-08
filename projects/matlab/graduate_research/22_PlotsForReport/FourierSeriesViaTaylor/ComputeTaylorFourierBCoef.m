function [b] = ComputeTaylorFourierBCoef(n, gamma, M, bernoulli_table)

b = 0;

for m = n:M
    bernoulli_2m = LookupNthBernoulliNumber(2*m, bernoulli_table);
    numerator = (-1).^(2*m-n-1)*(2^(2*m+1)-2)*bernoulli_2m;    
    denominator = m*factorial(m-n)*factorial(m+n-1);
    b = b + numerator/denominator*gamma^(2*m-1);
end

end

