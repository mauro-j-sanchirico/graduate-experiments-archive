%% Direct Interrogation with Equivalency Check
%% Interrogate by optimizing to meet recorded points

clc; clear; close all;
RunInitializationRoutine

set(groot, 'defaultAxesFontSize', 18);

rng(4);

%% Build a practical neural net and visualize its performance

fprintf('Building neural net...\n');

% Instantiate two exactly equal random MPLs
mlp_params1 = GetRandomMLPParams();
mlp_params2 = mlp_params1;

[x_inputs_grid, ~, ~, x_inputs_sweep] = Generate2DFeatureSpace();

y_outputs_grid1 = EvalMLP(mlp_params1, x_inputs_grid);
y_outputs_grid2 = EvalMLP(mlp_params2, x_inputs_grid);


%% Interrogation

% Pre-generate tables
fprintf('Loading tables...\n');
alpha_coefs = GetPolyCoefsTanh();
[mi_table, mc_table] = GetMultinomialTables();

% Get output response of both networks
meas_snr = inf;
[t, x_stimulus] = GetSinusoidalStimuli();
y_measured1 = CollectResponse(mlp_params1, x_stimulus, meas_snr);
y_measured2 = CollectResponse(mlp_params2, x_stimulus, meas_snr);

fprintf('Comparing MLPs...\n');
[e, psi_flat1, psi_flat2] = CompareMLPs( ...
    mlp_params1, mlp_params2, alpha_coefs, mi_table, mc_table);

% Visualize the path along the output manifold
save_location = './Images/2DClassificationContourCoverageBWExactlyEqual.png';

Visualize2DOutputComparisonBW( ...
    x_inputs_grid, ...
    y_outputs_grid1, y_outputs_grid2, ...
    psi_flat1, psi_flat2, e, ...
    save_location);

fprintf('MLP error metric: %f\n', e)
