%% ComputeMuFunctionTableLookup
%
% @brief Computes the mu function from a lookup table
%
% @details The mu function is defined for all integers n,L >= 0.  We look
% up values using Matlab indicies, so to look up mu(n,L) we need to access
% the value in the table that lies at indicies n+1 and L+1.
%
% @param[in] n - The n argument of the mu function (integer)
%
% @param[in] L - The L argument of the mu function (integer)
%
% @param[in] mu_table - The precomputed mu lookup table
%
% @returns The exact value of the mu function
%
function mu = ComputeMuFunctionLookupTable(n, L, mu_table)
mu = mu_table(n+1, L+1);
end

