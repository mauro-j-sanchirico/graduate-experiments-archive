%% GetTanhCoefs
%
% @brief Returns a vector of coefs for the tanh Taylor Series
% @details Uses vectorized computation for efficiency
% @param[in] n - Number of coefs
% @returns a_coefs - The length n vector of coefficients
%
function [a_coefs] = GetTanhCoefs(n)
even_idxs = 2:2:(2*n);
a_coefs = ...
    2.^(even_idxs).*(2.^(even_idxs)-1).*bernoulli(even_idxs)...
       ./factorial(even_idxs);
end
