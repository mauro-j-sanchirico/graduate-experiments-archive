%% EvaluateMultivariatePolynomial
%
% @breif Evaluates a multivariate polynomial
%
% @param[in] coefficients - A vector representing the coefficients of the
% polynomial in degree negative lexiconographical ordering.
%
% @param[in] exponents - A matrix representing the exponents of each
% variable in each term in degree negative lexiconographical ordering.
%
% @param[in] x_query_point - The point at which the multivariate
% polynomial is to be evaluated x = [x1 x2 ... xM]
%
% @returns y_eval_point - The evaluated point y = f(x)
%

function y_eval_point = EvaluateMultivariatePolynomial( ...
            coefficients, exponents, x_query_point)

% Initialize the eval point
y_eval_point = 0;
        
% Loop through each term in the multivariate polynomial
for term_idx = 1:length(coefficients)
    
    term = coefficients(term_idx);
    exponent_vector = exponents(term_idx, :);

    % Loop through the exponents in the exponent vector
    for exponent_idx = 1:length(exponent_vector)
        base = x_query_point(exponent_idx);
        exponent = exponent_vector(exponent_idx);
        term = term*base^exponent;
    end
    
    y_eval_point = y_eval_point + term;
    
end

end
