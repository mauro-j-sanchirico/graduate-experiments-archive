%% Comparison Examples
%% Examples of MLPs with Different Types of Equivalency

clc; clear; close all;
RunInitializationRoutine

set(groot, 'defaultAxesFontSize', 16);


%% Load required tables

fprintf('0) Loading tables...\n');
alpha_coefs = GetPolyCoefsTanh();
[mi_table, mc_table] = GetMultinomialTables();


%% Compare two exactly equivalent MLPs

fprintf('Comparing exactly equivalent MLPs...\n');
mlp_params1 = GetRandomMLPParams();
mlp_params2 = mlp_params1;

[e, psi_flat1, psi_flat2] = CompareMLPs( ...
    mlp_params1, mlp_params2, alpha_coefs, mi_table, mc_table);

e

[x_inputs_grid, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace();

y_outputs_grid1 = EvalMLP(mlp_params1, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid1);

y_outputs_grid2 = EvalMLP(mlp_params2, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid2);


%% Compare two symetric MLPs
%
% Created by sign flipping

fprintf('Comparing symetrically equivalent MLPs...\n');
mlp_params1 = GetRandomMLPParams();
mlp_params2 = mlp_params1;

% Flip signs for an obvious symetry
mlp_params2.w_layer0 = -1*mlp_params2.w_layer0;
mlp_params2.b_layer0 = -1*mlp_params2.b_layer0;
mlp_params2.w_layer1 = -1*mlp_params2.w_layer1;
mlp_params2.b_layer1 = -1*mlp_params2.b_layer1;

[e, psi_flat1, psi_flat2] = CompareMLPs( ...
    mlp_params1, mlp_params2, alpha_coefs, mi_table, mc_table);

e

[x_inputs_grid, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace();
y_outputs_grid1 = EvalMLP(mlp_params1, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid1);
y_outputs_grid2 = EvalMLP(mlp_params2, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid2);


%% Compare two symetric MLPs
%
% Created by neuron exchanging

fprintf('Comparing symetrically equivalent MLPs...\n');
mlp_params1 = GetRandomMLPParams();
mlp_params2 = mlp_params1;

% Exchange weights for an obvious symetry
mlp_params2.w_layer0 = flipud(mlp_params1.w_layer0);
mlp_params2.b_layer0 = flipud(mlp_params2.b_layer0);
mlp_params2.w_layer1 = fliplr(mlp_params2.w_layer1);

[e, psi_flat1, psi_flat2] = CompareMLPs( ...
    mlp_params1, mlp_params2, alpha_coefs, mi_table, mc_table);

e

[x_inputs_grid, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace();
y_outputs_grid1 = EvalMLP(mlp_params1, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid1);
y_outputs_grid2 = EvalMLP(mlp_params2, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid2);

%% Compare two strongly equivalent MLPs
%
% created by adding small errors to the last layer

w_error = 0.00001;

fprintf('Comparing closely equivalent MLPs...\n');
mlp_params1 = GetRandomMLPParams();
mlp_params2 = mlp_params1;
mlp_params2.w_layer1(1) = mlp_params2.w_layer1(1) + w_error;

[e, psi_flat1, psi_flat2] = CompareMLPs( ...
    mlp_params1, mlp_params2, alpha_coefs, mi_table, mc_table);

e

[x_inputs_grid, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace();
y_outputs_grid1 = EvalMLP(mlp_params1, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid1);
y_outputs_grid2 = EvalMLP(mlp_params2, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid2);

%% Compare two deceptively un-equivalent MLPs
%
% Created by adding small errors to the first layer

w_error = 0.00001;

fprintf('Comparing closely equivalent MLPs...\n');
mlp_params1 = GetRandomMLPParams();
mlp_params2 = mlp_params1;
mlp_params2.w_layer0(1,2) = mlp_params2.w_layer1(1,2) + w_error;

[e, psi_flat1, psi_flat2] = CompareMLPs( ...
    mlp_params1, mlp_params2, alpha_coefs, mi_table, mc_table);

e

[x_inputs_grid, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace();
y_outputs_grid1 = EvalMLP(mlp_params1, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid1);
y_outputs_grid2 = EvalMLP(mlp_params2, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid2);

%% Compare two strongly unequivalent MLPs
%
% Created by adding large errors to the first layer

w_error = -1;

fprintf('Comparing un-equivalent MLPs...\n');
mlp_params1 = GetRandomMLPParams();
mlp_params2 = mlp_params1;
mlp_params2.w_layer0(1,2) = mlp_params2.w_layer1(1,2) + w_error;

[e, psi_flat1, psi_flat2] = CompareMLPs( ...
    mlp_params1, mlp_params2, alpha_coefs, mi_table, mc_table);

e

[x_inputs_grid, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace();
y_outputs_grid1 = EvalMLP(mlp_params1, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid1);
y_outputs_grid2 = EvalMLP(mlp_params2, x_inputs_grid);
Visualize2DClassificationSurface(x_inputs_grid, y_outputs_grid2);
