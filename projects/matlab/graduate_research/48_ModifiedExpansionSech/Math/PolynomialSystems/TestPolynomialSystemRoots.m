%% TestPolynomialSystemRoots
%
% @breif Tests the roots of a polynomial system
%
% @details Evaluates the polynomial system at the proposed roots and
% checks if the results are all less than the given epsilon.  Each
% equation's result must be less than the given epsilon in order for the
% root to be declared valid.
%
% @param[in] polynomial_system_p - Polynomial system in Batselier format
%
% @param[in] proposed_roots_r - A QxM matrix where Q is the number of
% roots to be checked and M is the number of variables in the multivariate
% polynomial system.
%
% @param[in] threshold_epsilon - A threshold to which the result of each
% root's evaluation result will be compared.
% 
% @returns valid_root_flags - A vector of boolean flags indicating whether
% or not each proposed root was valid for the given epsilon.
%
% @returns evaluated_roots - The values
%

function valid_root_flags = TestPolynomialSystemRoots( ...
    polynomial_system_p, proposed_roots_r, threshold_epsilon)

% Determine the number of proposed roots to be evaluated
[num_roots_big_q, num_variables_m] = size(proposed_roots_r);

valid_root_flags = zeros(num_roots_big_q, 1);

for root_index_q = 1:num_roots_big_q
    
    % Initialize valid root flag
    valid_root_flag = true;
    
    % Extract one of the proposed roots
    proposed_root = proposed_roots_r(root_index_q, :);
    
    % Evaluate the polynomial system at the proposed root
    evaluated_roots_y = EvaluatePolynomialSystem( ...
        polynomial_system_p, proposed_root);
    
    % Check each root against the threshold
    for eval_point_index = 1:num_variables_m
        if abs(evaluated_roots_y(eval_point_index)) > threshold_epsilon
            valid_root_flag = false;
            break;
        end
    end
    
    valid_root_flags(root_index_q) = valid_root_flag;
    
end

end
