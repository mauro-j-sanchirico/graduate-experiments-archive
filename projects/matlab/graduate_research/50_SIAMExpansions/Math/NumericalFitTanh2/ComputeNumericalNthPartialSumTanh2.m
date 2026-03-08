function y = ComputeNumericalNthPartialSumTanh2(big_n, r, dx, x)
coefs = ComputeNumericalPolyCoefsTanh2(big_n, r, dx);
y = polyval(coefs, x);
end
