%% SearchMLPParamsNumericalFromPoints
%
% @breif Given a stimulus and a measured response numerically solves for
% the found MLP parameters that yeild output as close as possible to the
% measured output in the least squares sense.
%
% @param[in] x_stimulus - The input stimulus represented as a matrix where
% each row is one input and each column is one sample.
%
% @param[in] y_measured - The measured response to the stimulus where the
% response to each input is represented one element of the vector.
%
% @returns found_mlp_params - The MLP parameter structure populated with
% found MLP parameters.
%

function found_mlp_params = ...
    SearchMLPParamsNumericalFromPoints(x_stimulus, y_measured)

% Get configuration parameters
analysis_params = GetAnalysisParams();

% Get an initial starting point
mlp_init_params = GetRandomMLPParams();
mlp_init_param_vector = ConvertMLPParamsToVector(mlp_init_params);

mlp_init_param_vector = ...
    mlp_init_param_vector*analysis_params.init_search_weight_multiplier;

% Define the optimization function for two inputs
optim_func = @(mlp_param_vector) EvalMLPCostFunction( ...
    mlp_param_vector, x_stimulus, y_measured);

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
options.FunctionTolerance = 1.0e-10;
options.OptimalityTolerance = 1.0e-10;

% Get the optimal MLP parameter vector
found_mlp_param_vector = lsqnonlin( ...
    optim_func, mlp_init_param_vector, low_bound, high_bound, options);

% Convert the parameter vector to an MLP parameter struct
found_mlp_params = ConvertVectorToMLPParams(found_mlp_param_vector);

end

