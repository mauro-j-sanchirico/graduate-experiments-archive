%% ComputeQFunctionLookupTable
%
% @brief Computes the q function from a lookup table
%
% @details The q function is defined for all integers m,L >= 0.  We look
% up values using Matlab indicies, so to look up mu(m,L) we need to access
% the value in the table that lies at indicies m+1 and L+1.
%
% @param[in] m - The m argument of the q function (integer)
%
% @param[in] L - The L argument of the q function (integer)
%
% @param[in] q_table - The precomputed q lookup table
%
% @returns The exact value of the q function
%
function q = ComputeQFunctionLookupTable(n, L, q_table)
q = q_table(n+1, L+1);
end

