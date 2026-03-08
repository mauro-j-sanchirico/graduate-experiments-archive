function mlp_params = SearchMLPParamsNumericalFromCoefs( ...
    numerical_poly_coefs, alpha_coefs)

% Get an nchoosek table to evaluate the coefs
nchoosek_table_struct = load('./Math/FastNChooseK/nchoosek_table.mat');
nchoosek_table = nchoosek_table_struct.nchoosek_table;

% Get configuration parameters
analysis_params = GetAnalysisParams();
mlp_hyperparams = GetMLPHyperparams();

% Get an initial starting point
mlp_init_params = GetRandomMLPParams();
mlp_init_param_vector = ConvertMLPParamsToVector(mlp_init_params);

optim_func = @(mlp_param_vector) EvalPolyCoefsCostFunction( ...
    mlp_param_vector, nchoosek_table, alpha_coefs, ...
    numerical_poly_coefs, analysis_params.n_interrogation_coefs);

low_bound = -ones(size(mlp_init_param_vector))*analysis_params.max_weight;
high_bound = ones(size(mlp_init_param_vector))*analysis_params.max_weight;

options = optimoptions('lsqnonlin', 'Display', 'iter-detailed');
%options.Algorithm = 'levenberg-marquardt';
options.MaxFunctionEvaluations = 1.5e4;
options.StepTolerance = 1.0e-9;
%options.StepTolerance = 
found_mlp_param_vector = lsqnonlin( ...
    optim_func, mlp_init_param_vector, low_bound, high_bound, options);

mlp_params = ConvertVectorToMLPParams(found_mlp_param_vector);

end

