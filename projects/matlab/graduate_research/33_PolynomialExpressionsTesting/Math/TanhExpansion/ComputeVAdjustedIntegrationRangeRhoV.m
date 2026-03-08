%% ComputeVAdjustedIntegrationRangeRhoV
%
% @breif Computes the upper integration range adjusted for activation
% function inputs v
%
% @details Implemented according to Theorem IVb "Complete analytic
% modified series expansion of the hyperbolic tangent"
%
% @param[in] number_partial_sum_terms_ns - The number of terms in the
% partial sum expansion of the hyperbolic tangent
%
% @param[in] max_v - The maximum value that will be seen at input to the
% activation function, i.e. the maximum of the signal v
%
% @returns rho_v - The upper range of the integral adjusted
%

function rho_v = ComputeVAdjustedIntegrationRangeRhoV( ...
    number_partial_sum_terms_ns, max_v)

q1 = 0.8129;
q0 = 1.3991;

rho = q1*number_partial_sum_terms_ns + q0;
rho_v = rho / max_v;

end
