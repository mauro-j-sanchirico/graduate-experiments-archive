function coefs = ComputeModifiedPolyCoefsSech2(big_n, r)
coefs = ComputeModifiedNthCoefSech2(big_n:-1:0, floor(big_n/2), r);
end
