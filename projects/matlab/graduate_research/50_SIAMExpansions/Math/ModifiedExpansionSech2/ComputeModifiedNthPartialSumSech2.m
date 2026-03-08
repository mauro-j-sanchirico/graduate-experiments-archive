function y = ComputeModifiedNthPartialSumSech2(big_n, r, x)
coefs = ComputeModifiedPolyCoefsSech2(big_n, r);
y = polyval(coefs, x);
end

