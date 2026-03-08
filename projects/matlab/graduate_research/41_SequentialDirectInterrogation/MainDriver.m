%% Direct Interrogation Attempt
%% Attempt to interrogate by optimizing to meet recorded points

clc; clear; close all;

set(groot, 'DefaultTextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 12);

addpath('./Analysis/');
addpath('./DataGeneration/');
addpath('./Interrogation/');
addpath('./Inputs');
addpath('./Math/');
addpath('./Math/FastNChooseK/');
addpath('./Math/PolynomialTools/');
addpath('./Math/RhoTableBuilder/');
addpath('./Math/SinTaylorExpansion/');
addpath('./Math/TanhModifiedExpansion/');
addpath('./Math/TanhNumericalExpansion/');
addpath('./Math/TanhSumExpExpansion/');
addpath('./Math/TanhTaylorExpansion/');
addpath('./MLP/');
addpath('./Visualization/');

rng(1);


%% Build a practical neural net and visualize its performance

mlp_params = GetRandomMLPParams();

[x_inputs_grid, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace();

y_outputs = EvalMLP(mlp_params, x_inputs_grid);

% Visualize the classification boundary
Visualize2DClassificationSurface(x_inputs_grid, y_outputs);

% Visualize response when one input is zero
y_neq1_zero = EvalMLP(mlp_params, x_neq1_zero); % Force x1 to 0
y_neq2_zero = EvalMLP(mlp_params, x_neq2_zero); % Force x2 to 0

VisualizeYForSingleActiveInputs( ...
    x_neq1_zero, x_neq2_zero, y_neq1_zero, y_neq2_zero);

% Verify that we can reconstruct the outputs from fundamental systems
VisualizeFundamentalMLPs(mlp_params, x_inputs_sweep);


%% Interrogation

analysis_params = GetAnalysisParams();

% ------------------------------------------------------------------------
% Step 0: pre-generate tables and coefficients
% ------------------------------------------------------------------------
alpha_coefs = GetPolyCoefsTanh();

% ------------------------------------------------------------------------
% Step 1: generate the input stimuli
% ------------------------------------------------------------------------
x_stimuli = GetSweepStimuli();

% ------------------------------------------------------------------------
% Step 2: collect responses
% ------------------------------------------------------------------------
y_measured = CollectResponses(mlp_params, x_stimuli);

% ------------------------------------------------------------------------
% Step 3: Numerically search for hidden weights resulting in the found
% responses for each stimulus
% ------------------------------------------------------------------------
found_mlp_params = SearchMLPParamsNumericalFromPoints( ...
    x_stimuli, y_measured, alpha_coefs);

% ------------------------------------------------------------------------
% Step 4: Check to see if the found parameters produce a neural network
% similar to the original neural network
% ------------------------------------------------------------------------
VisualizeFundamentalMLPs(found_mlp_params, x_inputs_sweep);
y_outputs_found_mlp = EvalMLP(found_mlp_params, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_found_mlp);
