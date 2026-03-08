%% ComputeKappaFunctionLookupTable
%
% @breif Computes the Kappa funciton using a lookup table
%
% @details The Kappa function is defined for all integers n,L >= 0.  We
% look up values using Matlab indicies, so to look up mu(n,L) we need to
% access the value in the table that lies at indicies n+1 and L+1.
%
% @param[in] n - The "n" parameter (integer) which denotes the Fourier
% series coefficient.
%
% @param[in] L - The parameter which denotes the power of gamma that this
% coefficient is attached to.
%
% @param[in] kappa_table - The kappa table to use for the lookup
%
% @returns Returns Kappa(n, l) as defined in the Kappa theorem.
%
function kappa = ComputeKappaFunctionLookupTable(n, L, kappa_table)
kappa = kappa_table(n+1, L+1);
end

