function y = ComputeTaylorNthPartialSumTanh2(big_n, x)
coefs = ComputeTaylorPolyCoefsTanh2(big_n);
y = polyval(coefs, x);
end

