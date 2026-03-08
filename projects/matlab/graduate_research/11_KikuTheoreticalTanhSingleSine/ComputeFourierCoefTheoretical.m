%% ComputeFourierCoefTheoretical
%
% @breif Computes the nth fourier coefficient of tanh(gamma*sin(x))
%
% @details Uses the theoretical methods derived in "Single Sine Excitation
% of a Nonlinear Activation Unit" and "Expanding the Mu Function" (MJS)
% to get the fourier coefficient
%
% @param[in] n - The number of the Fourier Coefficient
%
% @param[in] gamma - The gain of the sinusoid at the input to the
% activation unit.
%
% @param[in] L_max - The number of powers of gamma to use in the
% approximation.

% @param[in] m_max - Where to truncate the Kappa function approximation
%
% @returns b - The Fourier Coefficient
%

function [b] = ComputeFourierCoefTheoretical(n, gamma, L_max, kappa_table)

b = 2/(2*n - 1);

for L = 0:L_max
    kappa = ComputeKappaFunctionLookupTable(n, L, kappa_table);
    b = b + kappa*gamma^L;
end

end
