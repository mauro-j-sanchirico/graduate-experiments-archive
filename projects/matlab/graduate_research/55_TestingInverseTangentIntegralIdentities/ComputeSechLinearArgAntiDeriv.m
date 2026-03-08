function y = ComputeSechLinearArgAntiDeriv(a, b, j, x)

summation = 0;

for k = 0:j
    term = factorial(j)*x^(j-k)*Ti(k+1, exp(-a*x - b)) ...
        / (factorial(j-k) * a^(k+1));
    summation = summation + term;
end

y = -2*summation;

end

