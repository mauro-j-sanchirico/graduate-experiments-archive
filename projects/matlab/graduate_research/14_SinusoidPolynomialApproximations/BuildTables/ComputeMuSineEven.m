function  mu_sine_even = ComputeMuSineEven(j, k)

if k >= j
    quotient = (-1)^k/factorial(2*k+1);
    binomial_coef = nchoosek(2*k+1, 2*j);
    mu_sine_even = quotient*binomial_coef;
else
    mu_sine_even = 0;
end

end

