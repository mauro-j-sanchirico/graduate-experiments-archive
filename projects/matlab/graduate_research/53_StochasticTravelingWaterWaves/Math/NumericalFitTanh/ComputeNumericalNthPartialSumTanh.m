function y = ComputeNumericalNthPartialSumTanh(big_n, r, dx, x)
coefs = ComputeNumericalPolyCoefsTanh(big_n, r, dx);
y = polyval(coefs, x);
end
