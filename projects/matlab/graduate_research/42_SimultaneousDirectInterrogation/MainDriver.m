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
addpath('./Math/FastTrinomialCoef/');
addpath('./Math/PolynomialTools/');
addpath('./Math/RhoTableBuilder/');
addpath('./Math/SinTaylorExpansion/');
addpath('./Math/TanhModifiedExpansion/');
addpath('./Math/TanhNumericalExpansion/');
addpath('./Math/TanhSumExpExpansion/');
addpath('./Math/TanhTaylorExpansion/');
addpath('./MLP/');
addpath('./Sonification/');
addpath('./Visualization/');

rng(1);


%% Build a practical neural net and visualize its performance

mlp_params = GetRandomMLPParams();

[x_inputs_grid, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace();

y_outputs_grid = EvalMLP(mlp_params, x_inputs_grid);

% Visualize the classification boundary
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid);


%% Interrogation

analysis_params = GetAnalysisParams();

% ------------------------------------------------------------------------
% Step 0: pre-generate tables and coefficients
% ------------------------------------------------------------------------
alpha_coefs = GetPolyCoefsTanh();

% ------------------------------------------------------------------------
% Step 1: generate the input stimuli
% ------------------------------------------------------------------------
[t, x_stimulus] = GetSinusoidalStimuli();

% DEBUG: verify that the interrogation polynomials are capable of
% reconstructing the system
% Get the trinomial tables to evaluate the coefs
ti_struct = load('trinomial_indicies_table.mat');
tc_struct = load('trinomial_coefs_table.mat');
ti_table = ti_struct.trinomial_indicies_table;
tc_table = tc_struct.trinomial_coefs_table;

y_polytest = EvalInterrogationPolynomial2InputSimultaneous( ...
       analysis_params.active_input1, analysis_params.active_input2, ...
       mlp_params, alpha_coefs, ti_table, tc_table, x_stimulus);

% ------------------------------------------------------------------------
% Step 2: collect responses
% ------------------------------------------------------------------------
y_measured = CollectResponse(mlp_params, x_stimulus);

% Visualize the classification boundary
Visualize2DOutputSpaceCoverage( ...
    x_inputs_grid, y_outputs_grid, x_stimulus, y_measured);

% Compare measured y to the theoretical y given by the polynomial coefs
VisualizeMeasuredAndTheoreticalResponses( ...
    t, x_stimulus, y_polytest, y_measured);

% ------------------------------------------------------------------------
% Step 3: Numerically search for hidden weights resulting in the found
% responses for each stimulus
% ------------------------------------------------------------------------

if analysis_params.do_numerical_search
    found_mlp_params = SearchMLPParamsNumericalFromPoints( ...
        x_stimulus, y_measured, alpha_coefs);
end


%% Post Analysis

% Check to see if the found parameters produce a neural network similar
% to the original neural network
if analysis_params.do_numerical_search
    % Eval the found MLP params over a grid of inputs
    y_outputs_found_mlp = EvalMLP(found_mlp_params, x_inputs_grid);
    Visualize2DClassificationSurface(x_inputs_grid, y_outputs_found_mlp);
    
    % Eval the found MLP params for the given stimulus
    y_reconstructed = CollectResponse(found_mlp_params, x_stimulus);
    VisualizeMeasuredAndReconstructedResponses( ...
        t, x_stimulus, y_reconstructed, y_measured);
end

