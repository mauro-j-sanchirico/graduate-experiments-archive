%% ComputeKappaFunctionTheoretical
%
% @breif Computes a theoretical approximation to the Kappa function
%
% @details The Kappa function is defined by an infinite sum, so it must be
% approximated via a truncated sum.  The input parameter m_max defines the
% term to which we will truncate.
%
% @param[in] n - The "n" parameter (integer) which denotes the Fourier
% series coefficient.
%
% @param[in] L - The parameter which denotes the power of gamma that this
% coefficient is attached to.
%
% @param[in] m_max - The maximum number of terms to use in the sum.
%
% @param[in] mu_table - The mu table to use
%
% @param[in] q_table - The q table to use
%
% @returns kappa - An approximation of the Kappa function
%

function kappa = ...
    ComputeKappaFunctionTheoretical(n, L, m_max, mu_table, q_table)

kappa = 0;

% Switch to variable precision
L = vpa(L);

mu = ComputeMuFunctionLookupTable(n, L, mu_table);

for m = 1:m_max
    q = ComputeQFunctionLookupTable(m, L, q_table);
    kappa = kappa + q;
end

kappa = kappa*mu;

end
