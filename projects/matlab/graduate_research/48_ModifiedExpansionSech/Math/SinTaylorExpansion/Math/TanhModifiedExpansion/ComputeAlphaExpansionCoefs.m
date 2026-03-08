%% ComputeAlphaExpansionCoefs
%
% @breif Computes the expansion coefficient alpha giving a uniformly
% convergent expansion of the hyperbolic tangent
%
% @details Computed acccording to Theorem IVb "Complete analytic modified
% series expansion of the hyperbolic tangent"
%
% @param[in] number_terms_big_m - the number of partial sum terms to use
% in the expansion.
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
% integral of Theorem IVb when set to true, otherwise, uses the analytical
% method provided by the theorem.  Numerical integration is often faster
% and more accurate since the analytical method involves dividing large
% numbers.
%
% @returns alpha_coefs - the vector of coefficients which can be used in
% a uniformly convergent expansion to the hyperbolic tangent.
%

function alpha_coefs = ComputeAlphaExpansionCoefs( ...
    number_terms_big_m, epsilon, dxi, max_v, ...
    rho_table, numerical_integral_flag)

alpha_coefs = zeros(1, number_terms_big_m);

for m_index = 1:number_terms_big_m
    
    fprintf('Computing alpha coef. %i/%i\n', ...
        m_index, number_terms_big_m);
    
    j_index = 2*m_index - 1;
    alpha_coefs(m_index) = ComputeAlphaExpansionCoef( ...
       j_index, number_terms_big_m, ...
       epsilon, dxi, max_v, rho_table, numerical_integral_flag);
    
end

end

