%% ComputeQFunctionTheoretical
%
% @brief Computes the "q(m,l)" function analytically
% 
% @param[in] m - The "m" parameter (integer)
%
% @param[in] L - The "l" parameter (integer)
%
% @returns q - The analytical value of the "q(m,l)" function
%

function q = ComputeQFunctionTheoretical(m, L)
q = (-1)^(m+L)*(2)^(L+1)*m^(L)/factorial(L);
end

