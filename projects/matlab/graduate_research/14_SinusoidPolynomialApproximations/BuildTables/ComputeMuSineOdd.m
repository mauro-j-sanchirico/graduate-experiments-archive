function  mu_sine_odd = ComputeMuSineOdd(j, k)

if k >= j
    quotient = (-1)^k/factorial(2*k+1);
    binomial_coef = nchoosek(2*k+1, 2*j+1);
    mu_sine_odd = quotient*binomial_coef;
else
    mu_sine_odd = 0;
end

end

