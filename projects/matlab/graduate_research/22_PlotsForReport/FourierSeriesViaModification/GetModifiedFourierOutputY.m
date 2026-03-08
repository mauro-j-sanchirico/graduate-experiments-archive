function y_output = GetModifiedFourierOutputY(gamma, N_f, N_t, psi)

v = gamma*sin(psi);

q1 = 0.8129;
q0 = 1.3991;

rho_range_of_taylor_validity = q1*N_t + q0;

% Estimate the range in which the taylor series is valid.
% It is better to over-estimate than it is to under-estimate.
r_range_of_taylor_validity = rho_range_of_taylor_validity/(max(v)*1.5);

[a, b, ~, n] = ComputeModifiedFourierSeries( ...
    gamma, N_f, N_t, r_range_of_taylor_validity, psi);
y_output = ComputeReconstructedFunctionFromFourierSeries(a, b, n, psi);

end

