function y = ComputeModifiedNthPartialSumSech(big_n, r, x)
coefs = ComputeModifiedPolyCoefsSech(big_n, r);
y = polyval(coefs, x);
end