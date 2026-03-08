function coefs = ComputeModifiedPolyCoefsTanh(big_n, r)
coefs = ComputeModifiedNthCoefTanh(big_n:-1:0, floor(big_n/2), r);
end
