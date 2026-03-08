%% Generate Expansion Plots
%% Generates expansion plots for hyperbolic tangent analysis

clc; clear; close all;

addpath('./BuildLookupTables');
addpath('./FourierSeriesViaExponential');
addpath('./FourierSeriesViaModification');
addpath('./FourierSeriesViaTaylor');
addpath('./Math');
addpath('./Math/LookupTables')
addpath('./Plots');
addpath('./PlotUtils');
addpath('./Simulations');
addpath('./Truth');

design_flags = GetDesignFlags();

% Precompute tables for desired design parameters
ChangeDirAndGenerateAllTables();

% Run sims for truth and all expansions over several gammas
fprintf('Running sims over gamma lists...\n');
[gamma_lists_inputs, gamma_lists_outputs] = RunAllGammaListSims();
fprintf('    Done.\n');

% Run sims computing errors for all expansions wrt. gamma
fprintf('Running sims over gamma sweep...\n');
[gamma_sweep_input, gamma_sweep_errors] = RunAllGammaSweepSims();
fprintf('    Done.\n');

% Plots
GenerateGammaListPlots(gamma_lists_inputs, gamma_lists_outputs);
GenerateGammaSweepPlots( ...
    gamma_sweep_input, gamma_sweep_errors);
