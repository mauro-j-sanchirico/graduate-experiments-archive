function y = ComputeTaylorNthPartialSumSech(big_n, x)
coefs = ComputeTaylorPolyCoefsSech(big_n);
y = polyval(coefs, x);
end