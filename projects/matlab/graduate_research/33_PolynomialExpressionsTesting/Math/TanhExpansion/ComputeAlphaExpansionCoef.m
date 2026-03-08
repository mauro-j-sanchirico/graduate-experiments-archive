%% ComputeAlphaExpansionCoef
%
% @breif Computes the expansion coefficient alpha giving a uniformly
% convergent expansion of the hyperbolic tangent
%
% @details Computed acccording to Theorem IVb "Complete analytic modified
% series expansion of the hyperbolic tangent"
%
% @param[in] j_index - the index of the antiderivatives to be computed
% inorder to find the alpha coefficient.  j = 2m - 1.
%
% @param[in] number_partial_sum_terms_ns - the number of partial sum terms
% to use in the expansion.
%
% @param[in] epsilon - The near zero value to evaluate the limit as the
% Eta antiderivative's argument approaches zero.
%
% @param[in] max_v - the maximum value expected at the input to the
% activation function, i.e. the max of the signal "v"
%
% @param[in] numerical_integral_flag - uses numerical methods to compute
% integral of Theorem IVb when set to true, otherwise, uses the analytical
% method provided by the theorem.  Numerical integration is often faster
% and more accurate since the analytical method involves dividing large
% numbers.
%
% @returns alpha_coef - the coefficient cooresponding to the 2m - 1 power
% of v in the uniformly convergent expansion of tanh(v)
%
function alpha_coef = ComputeAlphaExpansionCoef( ...
    j_index, number_partial_sum_terms_ns, ...
    epsilon, max_v, numerical_integral_flag)

m = (j_index + 1)/2;

rho_v = ComputeVAdjustedIntegrationRangeRhoV( ...
    number_partial_sum_terms_ns, max_v);

if numerical_integral_flag
    
    a = pi/2;
    xi = epsilon:epsilon:rho_v;
    integrand = xi.^j_index.*csch(a*xi);
    integral = trapz(xi, integrand);
    
else
    
    big_eta_antiderivative_at_rho_v = ...
        ComputeEtaAntiderivative(j_index, rho_v);

    big_eta_antiderivative_at_epsilon_v = ...
        ComputeEtaAntiderivative(j_index, epsilon);

    integral = ...
        big_eta_antiderivative_at_rho_v ...
      - big_eta_antiderivative_at_epsilon_v;
  
end

alpha_coef = integral*(-1)^(m-1)/factorial(j_index);

end

