function y = ComputeTaylorNthPartialSumTanh(big_n, x)
coefs = ComputeTaylorPolyCoefsTanh(big_n);
y = polyval(coefs, x);
end

