function y = ComputeTaylorNthPartialSumSech2(big_n, x)
coefs = ComputeTaylorPolyCoefsSech2(big_n);
y = polyval(coefs, x);
end

