function analysis_params = GetAnalysisParams()

% Maximum value of a neural network weight
analysis_params.max_weight = 2.5;

% Maximum value of a feature
analysis_params.max_feature_value = 1;

% Number of divisions per feature for grid visualizations
analysis_params.n_feature_points = 25;

% Number of points to use when interrogating the system
analysis_params.n_interrogation_points = 300;

% Set to true to generate new alpha coefficients, o.w. uses saved
analysis_params.gen_new_alphas = false;

% Set to true to visually check interrogation polynomials
analysis_params.check_polynomials = true;

% Set to true to visually verify that the coefficients of the fit
% interrogation polynomials equal the theoretically expected values
analysis_params.compare_polynomials = true;

% Recomended: > ceil((NH*NI + 2*NH + NO)/ 2)
analysis_params.n_interrogation_coefs = 7;

end
