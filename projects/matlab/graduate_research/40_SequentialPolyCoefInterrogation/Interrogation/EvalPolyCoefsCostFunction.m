function cost_vector = EvalPolyCoefsCostFunction( ...
    mlp_param_vector, nchoosek_table, alpha_coefs, ...
    numerical_poly_coefs, n_coefs)

mlp_params = ConvertVectorToMLPParams(mlp_param_vector);

interrogation_coefs = ComputeInterrogationPolynomials( ...
    mlp_params, nchoosek_table, alpha_coefs);

% Get last n coefs (i.e. first n smallest powers) for all rows
numerical_poly_coefs_trunc = ...
    numerical_poly_coefs(:, end:-1:end-n_coefs+1);
interrogation_coefs_trunc = interrogation_coefs(:, end:-1:end-n_coefs+1);

cost_vector = ...
    numerical_poly_coefs_trunc(:) - interrogation_coefs_trunc(:);

end

