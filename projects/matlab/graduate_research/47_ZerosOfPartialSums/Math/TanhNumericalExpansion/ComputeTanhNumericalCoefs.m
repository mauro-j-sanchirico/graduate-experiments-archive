function numerical_coefs = ...
    ComputeTanhNumericalCoefs(dv, vmin, vmax, n_coefs, fit_type)

v = (vmin:dv:vmax)';
y = tanh(v);

% Construct vandermonde matrix to solve least squares fit
polynomial_degree = n_coefs - 1;
v_matrix = ConstructVandermondeMatrix(v, polynomial_degree, fit_type);

% Solve least squares problem p = V\y to get polynomial coefficients
[q_v_matrix, r_v_matrix] = qr(v_matrix, 0);
numerical_coefs = r_v_matrix\(q_v_matrix'*y); % Same as p = V\y

% Poly coefs are a row vector by convention
numerical_coefs = numerical_coefs.';

if strcmp(fit_type, 'even')
    full_coefs = zeros(1, n_coefs);
    for full_coefs_index = 1:n_coefs
        index_is_even = ~mod(full_coefs_index, 2);
        if index_is_even
            partial_coefs_index = full_coefs_index/2;
            full_coefs(full_coefs_index) = ...
                numerical_coefs(partial_coefs_index);
        end
    end
    numerical_coefs = full_coefs;
elseif strcmp(fit_type, 'odd')
    full_coefs = zeros(1, n_coefs);
    for full_coefs_index = 1:n_coefs
        index_is_odd = mod(full_coefs_index, 2);
        if index_is_odd
            partial_coefs_index = (full_coefs_index+1)/2;
            full_coefs(full_coefs_index) = ...
                numerical_coefs(partial_coefs_index);
        end
    end
    numerical_coefs = full_coefs;
end

end
