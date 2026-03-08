function analysis_params = GetAnalysisParams()

% -------------------------------------------------------------------
% Maximum values
% -------------------------------------------------------------------

% Maximum value of a neural network weight
analysis_params.max_weight = 1;

% Maximum value of a feature
analysis_params.max_feature_value = 1;

% --------------------------------------------------------------------
% Equivalency Testing
% --------------------------------------------------------------------

% Number of multi-indicies to check during equivalency test (set to
% inf to check all)
analysis_params.n_multi_index_max = 80;

% Number of alpha coefs to use in the equivalency test (set to inf to use
% them all)
analysis_params.n_alpha_equiv_test = 20;

% Set to true to generate new alpha coefficients, o.w. uses saved
analysis_params.gen_new_alphas = false;

% ---------------------------------------------------------------------
% Input Signal Params
% ---------------------------------------------------------------------

% Number of points to use when interrogating the system (if multiple
% combinations of frequencies are used then each frequency gets
% n_interrogation_points)
analysis_params.n_interrogation_points = 1500;

% Matrix of frequency multipliers for sequential multi-input interrogation
% Number of columns = number of inputs, number of rows = number of signals
% in the sequence.  Each interrogation sequence stimulates on input with
% one tone (rad/s)
analysis_params.frequency_matrix = [ ...
    2*pi*5 2*pi*4;
    %2*pi*7 2*pi*4;
];

% ---------------------------------------------------------------------
% Optimizer Params
% ---------------------------------------------------------------------

% Weight multiplier to multiply initial weights by when initializing
% optimizers.
analysis_params.init_search_weight_multiplier = 0.001;
analysis_params.max_solver_fn_evals = 10000;
analysis_params.max_optimization_attempts = 20;
analysis_params.repeat_optimization_tolerance = 1e-8;

% ---------------------------------------------------------------------
% Debug Functions
% ---------------------------------------------------------------------

% Set to true to use expanded form of polynomials (expensive but more
% similar to how the system would be solved formally via numerical
% continuation).  This value is only used in debug steps.
analysis_params.use_expanded_polynomials = false;

% ---------------------------------------------------------------------
% Visualization Functions
% ---------------------------------------------------------------------

% Number of divisions per feature for grid visualizations
analysis_params.n_feature_points = 25;

end
