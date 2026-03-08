%% Direct Interrogation with Equivalency Check
%% Interrogate by optimizing to meet recorded points

clc; clear; close all;
RunInitializationRoutine

set(groot, 'defaultAxesFontSize', 18);
rng(103);

%% Build a neural net and visualize its performance

mlp_params = GetRandomMLPParams();
[x_inputs_grid, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace();
y_outputs_grid = EvalMLP(mlp_params, x_inputs_grid);


%% Interrogation

snr = inf;
[t, x_stimulus] = GetSinusoidalStimuli();
y_measured = CollectResponse(mlp_params, x_stimulus, snr);

save_str1 = 'Images/ExampleStimulusCoverageBW.png';
save_str2 = 'Images/ExampleStimulusAndResponse.png';
fundamental_period = 1;
Visualize2DOutputSpaceCoverageBW( ...
    x_inputs_grid, y_outputs_grid, ...
    x_stimulus, t, y_measured, ...
    save_str1, save_str2, ...
    fundamental_period);

VisualizeOutputSpectrum(t, y_measured);
