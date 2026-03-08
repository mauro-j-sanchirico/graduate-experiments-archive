function y_output = GetTaylorFourierOutputY(gamma, N, M, psi)

[a, b, ~, n] = ComputeTaylorFourierSeries(gamma, N, M);
y_output = ComputeReconstructedFunctionFromFourierSeries(a, b, n, psi);

end

