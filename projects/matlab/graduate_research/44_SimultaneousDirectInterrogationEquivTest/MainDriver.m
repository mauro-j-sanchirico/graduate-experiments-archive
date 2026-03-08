%% Direct Interrogation with Equivalency Check
%% Interrogate by optimizing to meet recorded points

clc; clear; close all;
RunInitializationRoutine

%% Build a practical neural net and visualize its performance

fprintf('Building neural net...\n');

% Instantiate a random MPL
mlp_params = GetRandomMLPParams();

[x_inputs_grid, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace();

y_outputs_grid = EvalMLP(mlp_params, x_inputs_grid);

% Visualize the classification boundary
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid);

fprintf('Built neural net with parmeters:\n');
PrintMLP(mlp_params);


%% Interrogation

fprintf('Starting interrogation...\n');

% -----------------------------------------------------------------------
% Step 0: pre-generate tables and coefficients
% -----------------------------------------------------------------------
fprintf('0) Loading tables...\n');
alpha_coefs = GetPolyCoefsTanh();
[mi_table, mc_table] = GetMultinomialTables();

% -----------------------------------------------------------------------
% Step 1: generate the input stimuli
% -----------------------------------------------------------------------
fprintf('1) Stimulating neural network...\n');
[t, x_stimulus] = GetSinusoidalStimuli();

% DEBUG STEP: verify that the interrogation polynomials are capable of
% reconstructing the system

fprintf('DEBUG STEP: verifying polynomials match neural net...\n');

y_polytest = EvalInterrogationPolynomial( ...
       mlp_params, alpha_coefs, mi_table, mc_table, x_stimulus);

% -----------------------------------------------------------------------
% Step 2: collect noisy responses
% -----------------------------------------------------------------------
fprintf('2) Measuring response...\n');
y_measured = CollectResponse(mlp_params, x_stimulus);

% Visualize the path along the output manifold
Visualize2DOutputSpaceCoverage( ...
    x_inputs_grid, y_outputs_grid, x_stimulus, y_measured);

% Compare measured y to the theoretical y given by the polynomial coefs
VisualizeMeasuredAndTheoreticalResponses( ...
    t, x_stimulus, y_polytest, y_measured);

% Get the fourier spectrum of y
VisualizeOutputSpectrum(t, y_measured);

% -----------------------------------------------------------------------
% Step 3: numerically search for hidden weights resulting in the found
% responses for each stimulus in a parallel system
% -----------------------------------------------------------------------
fprintf('3) Searching for single weights solution...\n');
found_mlp_params = SearchMLPParamsNumericalFromPoints( ...
    x_stimulus, y_measured);

% -----------------------------------------------------------------------
% Step 4: validate that the hidden weights found define a neural network
% that is approximately equivalent to the original network
% -----------------------------------------------------------------------
fprintf('4) Comparing found MLP with original MLP...\n');
[e, psi_flat1, psi_flat2] = CompareMLPs( ...
    mlp_params, found_mlp_params, alpha_coefs, mi_table, mc_table);

fprintf('MLP error metric: %f', e)

%% Post Analysis
%
% Check visually to see if the found parameters produce a neural network
% similar to the original neural network.

% Eval the direct found MLP params over a grid of inputs
y_outputs_found_mlp_measured = EvalMLP( ...
    found_mlp_params, x_inputs_grid);

Visualize2DClassificationSurface( ...
    x_inputs_grid, y_outputs_found_mlp_measured);

% Eval the found MLP params for the given stimulus
y_reconstructed_measured = CollectResponse( ...
    found_mlp_params, x_stimulus);

VisualizeMeasuredAndReconstructedResponses( ...
    t, y_measured, y_reconstructed_measured);

fprintf('\nOriginal params:\n')
PrintMLP(mlp_params);

fprintf('\nFound params:\n')
PrintMLP(found_mlp_params);

