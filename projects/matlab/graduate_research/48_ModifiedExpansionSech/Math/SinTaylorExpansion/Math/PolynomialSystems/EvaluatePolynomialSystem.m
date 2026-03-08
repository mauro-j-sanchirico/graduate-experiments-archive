%% EvaluatePolynomialSystem
%
% @breif Evaluates a multivariate polynomial system at a single point x
%
% @details Can handle underdetermined, critically determined, or
% overdetermined systems.  The number of equations is given by N and the
% number of variables is given by M.  Q is the number of query points to
% evaluate at.
%
% When x_query_points
%
% @param[in] polysys - the polynomial system
%
% @param[in] x_query_points - points at which to evaluate the polynomial
% x = [x11 x12 ... x1M;
%      x21 x22 ... x2M;
%      ...
%      xQ1 xQ2 ... xQM]
%
% @returns y_eval_points - the evaluated points
% y = [y11 y12 ... y1N;
%      y21 y22 ... y2N;
%      ...
%      yQ1 yQ2 ... yQN]
%

function y_eval_points = EvaluatePolynomialSystem( ...
    polynomial_system_p, x_query_points)

% Determine the number of equations in the system
num_equations_big_n = length(polynomial_system_p);

% Determine the number of query points Q from the size of the matrix of
% query points
[num_query_points_big_q, ~] = size(x_query_points);

% Initialize a QxN matrix of evaluation points (each row is the result of
% the qth query point and each column cooresponds to the nth equation in
% the system)
y_eval_points = zeros(num_query_points_big_q, num_equations_big_n);

% Loop through the number of points to be evaluated
for point_idx_q = 1:num_query_points_big_q
    
    % The query point at which we will evaluate the system this iteration
    x_query_point = x_query_points(point_idx_q, :);
    
    % Loop through each equation in the polynomial system
    for equation_idx_n = 1:num_equations_big_n
        
        % Extract the coefficients and exponents of this equation
        coefficients = polynomial_system_p{equation_idx_n, 1};
        exponents = polynomial_system_p{equation_idx_n, 2};
        
        % Evaluate the equation at this point
        y_eval_point = EvaluateMultivariatePolynomial( ...
            coefficients, exponents, x_query_point);
        
        % Store evaluation of this point in the evaluated points matrix
        y_eval_points(point_idx_q, equation_idx_n) = y_eval_point;
        
    end
    
end
