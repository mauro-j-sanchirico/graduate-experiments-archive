function coefs = ComputeModifiedPolyCoefsTanh2(big_n, r)
coefs = ComputeModifiedNthCoefTanh2(big_n:-1:0, floor(big_n/2), r);
end
