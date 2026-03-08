function coefs = ComputeModifiedPolyCoefsSech(big_n, r)
coefs = ComputeModifiedNthCoefSech(big_n:-1:0, floor(big_n/2), r);
end
