function y = ComputeModifiedNthPartialSumTanh2(big_n, r, x)
coefs = ComputeModifiedPolyCoefsTanh2(big_n, r);
y = polyval(coefs, x);
end

