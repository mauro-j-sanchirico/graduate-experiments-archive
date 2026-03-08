function y = ComputeModifiedNthPartialSumTanh(big_n, r, x)
coefs = ComputeModifiedPolyCoefsTanh(big_n, r);
y = polyval(coefs, x);
end
