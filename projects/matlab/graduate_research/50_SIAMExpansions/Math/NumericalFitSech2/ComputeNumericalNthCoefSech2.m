function coefs = ComputeNumericalNthCoefSech2(n, big_n, r, dx)
if max(n) > big_n
    error('All coefs. n must be less than max coef big_n.')
end
coefs = ComputeNumericalPolyCoefsSech2(big_n, r, dx);
coefs = fliplr(coefs);
coefs = coefs(n+1);
end
