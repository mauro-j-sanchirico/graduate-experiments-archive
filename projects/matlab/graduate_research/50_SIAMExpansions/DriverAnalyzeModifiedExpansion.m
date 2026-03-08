%% Analyzes the modified expansion for a a class of solitons
%% Analyzes the modified polynomial coefficients and convergence

clc; clear; close all;

set(groot, 'defaulttextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 18);

addpath('Math/Integrals/CschIntegral');
addpath('Math/Integrals/SechIntegral');
addpath('Math/ModifiedExpansionSech');
addpath('Math/ModifiedExpansionSech2');
addpath('Math/ModifiedExpansionTanh');
addpath('Math/ModifiedExpansionTanh2');
addpath('Analysis');


%% Analyze the hyperbolic secant

fprintf('Analyzing the hyperbolic secant...\n');

% ----------------------------------------------------------------------
% Plot an approximation on (-8, 8)
% ----------------------------------------------------------------------
big_n = 130;
r_fit = 11;
r_plot = 8.5;

sech_modified_partial_sum_handle = ...
    @(big_n, x) ComputeModifiedNthPartialSumSech(big_n, r_fit, x);

fprintf('Plotting partial sum comparison...\n');
PlotPartialSumComparison( ...
    @sech, sech_modified_partial_sum_handle, ...
    big_n, r_plot, ...
    '$$x$$', ...
    sprintf( ...
        'True and approx. $$\\mathrm{sech}(x)$$ fit on $$(-%.1f, %.1f)$$', ...
        r_plot, r_plot) ...
    );

% ----------------------------------------------------------------------
% Plot convergence surface
% ----------------------------------------------------------------------

fprintf('Plotting convergence surface...\n');

big_n_max = 40;
r_fit = 5;
r_plot = 2*pi;

sech_modified_partial_sum_handle = ...
    @(big_n, x) ComputeModifiedNthPartialSumSech(big_n, r_fit, x);

PlotConvergenceSurface( ...
    @sech, sech_modified_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in Modified approx. of $$\mathrm{sech}(x)$$');

% ----------------------------------------------------------------------
% Plot coefficients
% ----------------------------------------------------------------------

fprintf('Plotting coefficients...\n');

big_n = 40;
r_fit = 5;

sech_modified_nth_coef_handle = ...
    @(n_list) ComputeModifiedNthCoefSech(n_list, big_n, r_fit);

PlotCoefs( ...
    sech_modified_nth_coef_handle, big_n_max, ...
    'Modified coefs. for $$\mathrm{sech}(x)$$');

fprintf('\n');


%% Analyze the hyperbolic secant-squared

fprintf('Analyzing the hyperbolic secant-squared...\n');

% ----------------------------------------------------------------------
% Plot an approximation on (-8, 8)
% ----------------------------------------------------------------------

big_n = 130;
r_fit = 11;
r_plot = 8.5;

sech2_modified_partial_sum_handle = ...
    @(big_n, x) ComputeModifiedNthPartialSumSech2(big_n, r_fit, x);

sech2 = @(x) sech(x).^2;

fprintf('Plotting partial sum comparison...\n');
PlotPartialSumComparison( ...
    sech2, sech2_modified_partial_sum_handle, ...
    big_n, r_plot, '$$x$$', ...
    sprintf( ...
        'True and approx. $$\\mathrm{sech}^2(x)$$ fit on $$(-%.1f, %.1f)$$', ...
        r_plot, r_plot) ...
    );

% ----------------------------------------------------------------------
% Plot convergence surface
% ----------------------------------------------------------------------

fprintf('Plotting convergence surface...\n');

big_n_max = 40;
r_fit = 5;
r_plot = 2*pi;

sech2_modified_partial_sum_handle = ...
    @(big_n, x) ComputeModifiedNthPartialSumSech2(big_n, r_fit, x);

PlotConvergenceSurface( ...
    sech2, sech2_modified_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in Modified approx. of $$\mathrm{sech}^2(x)$$');

% ----------------------------------------------------------------------
% Plot coefficients
% ----------------------------------------------------------------------

fprintf('Plotting coefficients...\n');

big_n = 40;
r_fit = 5;

sech2_modified_nth_coef_handle = ...
    @(n_list) ComputeModifiedNthCoefSech2(n_list, big_n, r_fit);

PlotCoefs( ...
    sech2_modified_nth_coef_handle, big_n_max, ...
    'Modified coefs. for $$\mathrm{sech}^2(x)$$');

fprintf('\n');


%% Analyze the hyperbolic tangent

fprintf('Analyzing the hyperbolic tangent...\n');

% ----------------------------------------------------------------------
% Plot an approximation on (-8, 8)
% ----------------------------------------------------------------------

big_n = 130;
r_fit = 11;
r_plot = 8.5;

tanh_modified_partial_sum_handle = ...
    @(big_n, x) ComputeModifiedNthPartialSumTanh(big_n, r_fit, x);

fprintf('Plotting partial sum comparison...\n');
PlotPartialSumComparison( ...
    @tanh, tanh_modified_partial_sum_handle, ...
    big_n, r_plot, '$$x$$', ...
    sprintf( ...
        'True and approx. $$\\mathrm{tanh}(x)$$ fit on $$(-%.1f, %.1f)$$', ...
        r_plot, r_plot) ...
    );

% ----------------------------------------------------------------------
% Plot convergence surface
% ----------------------------------------------------------------------

fprintf('Plotting convergence surface...\n');

big_n_max = 40;
r_fit = 5;
r_plot = 2*pi;

tanh_modified_partial_sum_handle = ...
    @(big_n, x) ComputeModifiedNthPartialSumTanh(big_n, r_fit, x);

PlotConvergenceSurface( ...
    @tanh, tanh_modified_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in Modified approx. of $$\mathrm{tanh}(x)$$');

% ----------------------------------------------------------------------
% Plot coefficients
% ----------------------------------------------------------------------

fprintf('Plotting coefficients...\n');

big_n = 40;
r_fit = 5;

tanh_modified_nth_coef_handle = ...
    @(n_list) ComputeModifiedNthCoefTanh(n_list, big_n, r_fit);

PlotCoefs( ...
    tanh_modified_nth_coef_handle, big_n_max, ...
    'Modified coefs. for $$\mathrm{tanh}(x)$$');

fprintf('\n');


%% Analyze the hyperbolic tangent-squared

fprintf('Analyzing the hyperbolic tangent-squared...\n');

% ----------------------------------------------------------------------
% Plot an approximation on (-8, 8)
% ----------------------------------------------------------------------

big_n = 130;
r_fit = 11;
r_plot = 8.5;

tanh2_modified_partial_sum_handle = ...
    @(big_n, x) ComputeModifiedNthPartialSumTanh2(big_n, r_fit, x);

tanh2 = @(x) tanh(x).^2;

fprintf('Plotting partial sum comparison...\n');
PlotPartialSumComparison( ...
    tanh2, tanh2_modified_partial_sum_handle, ...
    big_n, r_plot, '$$x$$', ...
    sprintf( ...
        'True and approx. $$\\mathrm{tanh}^2(x)$$ fit on $$(-%.1f, %.1f)$$', ...
        r_plot, r_plot) ...
    );

% ----------------------------------------------------------------------
% Plot convergence surface
% ----------------------------------------------------------------------

fprintf('Plotting convergence surface...\n');

big_n_max = 40;
r_fit = 5;
r_plot = 2*pi;

tanh2_modified_partial_sum_handle = ...
    @(big_n, x) ComputeModifiedNthPartialSumTanh2(big_n, r_fit, x);

PlotConvergenceSurface( ...
    tanh2, tanh2_modified_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in Modified approx. of $$\mathrm{tanh}^2(x)$$');

% ----------------------------------------------------------------------
% Plot coefficients
% ----------------------------------------------------------------------

fprintf('Plotting coefficients...\n');

big_n = 40;
r_fit = 5;

tanh2_modified_nth_coef_handle = ...
    @(n_list) ComputeModifiedNthCoefTanh2(n_list, big_n, r_fit);

PlotCoefs( ...
    tanh2_modified_nth_coef_handle, big_n_max, ...
    'Modified coefs. for $$\mathrm{tanh}^2(x)$$');

fprintf('\n');

