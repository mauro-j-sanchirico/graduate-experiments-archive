function found_mlp_params = SearchMLPParamsNumericalFromPoints( ...
    x_stimuli, y_measured, alpha_coefs)

% Get the trinomial tables to evaluate the coefs
ti_struct = load('trinomial_indicies_table.mat');
ti_table = ti_struct.trinomial_indicies_table;

tc_struct = load('trinomial_coefs_table.mat');
tc_table = tc_struct.trinomial_coefs_table;

% Get configuration parameters
analysis_params = GetAnalysisParams();

% Get an initial starting point
mlp_init_params = GetRandomMLPParams();
mlp_init_param_vector = ConvertMLPParamsToVector(mlp_init_params);

mlp_init_param_vector = ...
    mlp_init_param_vector*analysis_params.init_search_weight_multiplier;

% Define the optimization function for two inputs
optim_func = ...
    @(mlp_param_vector) EvalPointsCostFunction2InputSimultaneous( ...
        analysis_params.active_input1, analysis_params.active_input2, ...
        mlp_param_vector, ti_table, tc_table, alpha_coefs, ...
        x_stimuli, y_measured);

% Define the low and high bounds since the expansion is not valid beyond
% its region of covergence
low_bound = -ones(size(mlp_init_param_vector))*analysis_params.max_weight;
high_bound = ones(size(mlp_init_param_vector))*analysis_params.max_weight;

% Define optimizer options
%
% Note that options.Algorithm = 'levenberg-marquardt'; can only be used if
% there are no bounds.  We leave it off here since we want to bound the
% optimization inside the expansion's region of convergence.
options = optimoptions('lsqnonlin', 'Display', 'iter-detailed');
options.MaxFunctionEvaluations = analysis_params.max_solver_fn_evals;
options.StepTolerance = 1.0e-10;

% Get the optimal MLP parameter vector
found_mlp_param_vector = lsqnonlin( ...
    optim_func, mlp_init_param_vector, low_bound, high_bound, options);

% Convert the parameter vector to an MLP parameter struct
found_mlp_params = ConvertVectorToMLPParams(found_mlp_param_vector);

end

