%% ComputeAlphaSechExpansionCoef
%
% @breif Computes the expansion coefficient alpha giving a modified
% expansion of the hyperbolic secant
%
% @param[in] j_index - the index of the antiderivatives to be computed
% inorder to find the alpha coefficient.  j = 2m.
%
% @param[in] m_index_max - the number of partial sum terms to use in the
% expansion.
%
% @param[in] epsilon - The near zero value to evaluate the limit as the
% Eta antiderivative's argument approaches zero.
%
% @param[in] max_v - the maximum value expected at the input to the
% activation function, i.e. the max of the signal "v"
%
% @param[in] rho_table - the table to lookup rho values in.  Use
% rho_table = [] to estimate rho using a heuristic.
%
% @param[in] numerical_integral_flag - uses numerical methods to compute
% integral when set to true, otherwise, uses the analytica method.
% Numerical integration is often faster and more accurate since the
% analytical method involves dividing large numbers.
%
% @returns alpha_coef - the coefficient cooresponding to the 2m power
% of v in the modified expansion of sech(v)
%
function alpha_coef = ComputeAlphaSechExpansionCoef( ...
    j_index, m_index_max, epsilon, dxi, max_v, ...
    rho_table, numerical_integral_flag)

m_index = j_index/2;

rho_v = ComputeVAdjustedIntegrationRangeRhoSechV( ...
    m_index_max, max_v, rho_table);

if numerical_integral_flag
    
    a = pi/2;
    xi = epsilon:dxi:rho_v;
    integrand = xi.^j_index.*sech(a*xi);
    integral = trapz(xi, integrand);
    
else
    
    big_lambda_antiderivative_at_rho_v = ...
        ComputeLambdaSechAntiderivative(j_index, rho_v);

    big_lambda_antiderivative_at_epsilon_v = ...
        ComputeLambdaSechAntiderivative(j_index, epsilon);

    integral = ...
        big_lambda_antiderivative_at_rho_v ...
      - big_lambda_antiderivative_at_epsilon_v;
  
end

alpha_coef = integral*(-1)^(m_index)/factorial(j_index);

end

