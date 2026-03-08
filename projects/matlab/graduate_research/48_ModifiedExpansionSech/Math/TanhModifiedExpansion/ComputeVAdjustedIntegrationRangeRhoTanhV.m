%% ComputeVAdjustedIntegrationRangeRhoTanhV
%
% @breif Computes the upper integration range adjusted for activation
% function inputs v
%
% @param[in] number_partial_sum_terms_ns - The number of terms in the
% partial sum expansion of the hyperbolic tangent
%
% @param[in] max_v - The maximum value that will be seen at input to the
% activation function, i.e. the maximum of the signal v
%
% @param[in] rho_table - the table to lookup rho values in.  Use
% rho_table = [] to estimate rho using a heuristic.
%
% @returns rho_v - The upper range of the integral adjusted
%

function rho_v = ComputeVAdjustedIntegrationRangeRhoTanhV( ...
    number_terms_big_m, max_v, rho_table)

if isempty(rho_table)
    q1 = 0.8129;
    q0 = 1.3991;
    rho = q1*number_terms_big_m + q0;
else
    rho = rho_table(number_terms_big_m);
end

rho_v = rho / max_v;
    
end
