%% IEEE Paper
%% Analysis for IEEE Paper

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
poly_coefs_tanh_modified = GetPolyCoefsTanh();

% DEBUG: Visualize the interrogation polynomials using the theory so we
% can check that they agree with measurements
if analysis_params.check_polynomials
    VisualizeInterrogationPolynomials( ...
        mlp_params, poly_coefs_tanh_modified, x_inputs_sweep);
end

% ------------------------------------------------------------------------
% Step 1: generate the input stimuli
% ------------------------------------------------------------------------
x_stimuli = GetSweepStimuli();

% ------------------------------------------------------------------------
% Step 2: collect responses
% ------------------------------------------------------------------------
y_responses = CollectResponses(mlp_params, x_stimuli);

% ------------------------------------------------------------------------
% Step 3: get polynomial coefficients of responses
% ------------------------------------------------------------------------
numerical_poly_coefs = ...
    FitNumericalInterrogationPolynomials(x_stimuli, y_responses);

if analysis_params.check_polynomials
    nchoosek_table_struct = ...
        load('./Math/FastNChooseK/nchoosek_table.mat');
    nchoosek_table = nchoosek_table_struct.nchoosek_table;
    
    theoretical_poly_coefs = ComputeInterrogationPolynomials( ...
        mlp_params, nchoosek_table, poly_coefs_tanh_modified);

    VisualizeInterrogationCoefs( ...
        numerical_poly_coefs, theoretical_poly_coefs, x_stimuli)
end

% ------------------------------------------------------------------------
% Step 3: Numerically search for hidden weights resulting in the found
% polycoefs for each stimulus
% ------------------------------------------------------------------------
found_mlp_params = SearchMLPParamsNumericalFromCoefs( ...
    numerical_poly_coefs, poly_coefs_tanh_modified);

% ------------------------------------------------------------------------
% Step 4: Check to see if the found parameters produce a neural network
% similar to the original neural network
% ------------------------------------------------------------------------
VisualizeFundamentalMLPs(found_mlp_params, x_inputs_sweep);
y_outputs_found_mlp = EvalMLP(found_mlp_params, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_found_mlp);
