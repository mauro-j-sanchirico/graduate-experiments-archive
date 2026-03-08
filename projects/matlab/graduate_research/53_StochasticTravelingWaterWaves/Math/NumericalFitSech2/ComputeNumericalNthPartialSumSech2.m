function y = ComputeNumericalNthPartialSumSech2(big_n, r, dx, x)
coefs = ComputeNumericalPolyCoefsSech2(big_n, r, dx);
y = polyval(coefs, x);
end
