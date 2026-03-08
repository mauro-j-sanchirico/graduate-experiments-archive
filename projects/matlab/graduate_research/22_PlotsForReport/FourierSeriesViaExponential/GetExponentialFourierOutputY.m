function y_output = GetExponentialFourierOutputY(gamma, N, M, L, psi)

[a, b, ~, n] = ComputeExponentialFourierSeries(gamma, N, M, L);
y_output = ComputeReconstructedFunctionFromFourierSeries(a, b, n, psi);

end

