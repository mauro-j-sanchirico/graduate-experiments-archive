%% ComputeMuFunctionNumerical
%
% @brief Computes the mu function numerical
%
% @details Uses a simple numerical method
%
% @param[in] n - The n argument of the mu function (integer)
%
% @param[in] L - The L argument of the mu function (integer)
%
% @returns The numerical value of the mu function
%

function mu = ComputeMuFunctionNumerical(n, L)
    x=0:0.00001:pi;
    integrand = sin((2*n-1)*x).*(sin(x).^(L));
    mu = trapz(x, integrand);
end