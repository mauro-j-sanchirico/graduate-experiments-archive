function y = ComputeNumericalNthPartialSumSech(big_n, r, dx, x)
coefs = ComputeNumericalPolyCoefsSech(big_n, r, dx);
y = polyval(coefs, x);
end
