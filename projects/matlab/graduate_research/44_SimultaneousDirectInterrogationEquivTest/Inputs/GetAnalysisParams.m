function analysis_params = GetAnalysisParams()

% Maximum value of a neural network weight
analysis_params.max_weight = 2.5;

% Maximum value of a feature
analysis_params.max_feature_value = 1;

% Number of divisions per feature for grid visualizations
analysis_params.n_feature_points = 25;

% Number of points to use when interrogating the system (if multiple
% combinations of frequencies are used then each frequency gets
% n_interrogation_points)
analysis_params.n_interrogation_points = 1500;

% Set to true to generate new alpha coefficients, o.w. uses saved
analysis_params.gen_new_alphas = false;

% Matrix of frequency multipliers for sequential multi-input interrogation
% Number of columns = number of inputs, number of rows = number of signals
% in the sequence.  Each interrogation sequence stimulates on input with
% one tone (rad/s)
%analysis_params.frequency_matrix = [3 2; 5 4; 7 4; 9 8];
analysis_params.frequency_matrix = [ ...
    %2*pi*7 2*pi*4;
    2*pi*5 2*pi*4;
];

% Active inputs for multifrequency interrogation on polynomial systems
analysis_params.active_input1 = 1;
analysis_params.active_input2 = 2;

% Weight multiplier to multiply initial weights by when initializing
% optimizers.
analysis_params.init_search_weight_multiplier = 0.001;
analysis_params.max_solver_fn_evals = 10000;

% Set to true to use expanded form of polynomials (expensive but more
% similar to how the system would be solved formally via numerical
% continuation).
analysis_params.use_expanded_polynomials = false;

% Measurement signal to noise ratio
analysis_params.measurement_snr = 100;

end
