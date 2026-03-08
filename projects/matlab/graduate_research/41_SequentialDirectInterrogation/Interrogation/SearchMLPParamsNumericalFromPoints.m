function found_mlp_params = SearchMLPParamsNumericalFromPoints( ...
    x_stimuli, y_measured, alpha_coefs)

% Get an nchoosek table to evaluate the coefs
nchoosek_table_struct = load('./Math/FastNChooseK/nchoosek_table.mat');
nchoosek_table = nchoosek_table_struct.nchoosek_table;

% Get configuration parameters
analysis_params = GetAnalysisParams();

% Get an initial starting point
mlp_init_params = GetRandomMLPParams();
mlp_init_param_vector = ConvertMLPParamsToVector(mlp_init_params);

optim_func = @(mlp_param_vector) EvalPointsCostFunction( ...
    mlp_param_vector, nchoosek_table, alpha_coefs, ...
    x_stimuli, y_measured);

low_bound = -ones(size(mlp_init_param_vector))*analysis_params.max_weight;
high_bound = ones(size(mlp_init_param_vector))*analysis_params.max_weight;

options = optimoptions('lsqnonlin', 'Display', 'iter-detailed');
%options.Algorithm = 'levenberg-marquardt';
options.MaxFunctionEvaluations = 1.0e3;
options.StepTolerance = 1.0e-10;

found_mlp_param_vector = lsqnonlin( ...
    optim_func, mlp_init_param_vector, low_bound, high_bound, options);

found_mlp_params = ConvertVectorToMLPParams(found_mlp_param_vector);

end

