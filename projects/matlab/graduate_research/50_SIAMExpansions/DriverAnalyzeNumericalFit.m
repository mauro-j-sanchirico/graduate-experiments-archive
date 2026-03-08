%% Analyzes the numerical fit for a class of solitons
%% Analyzes the numerically fit polynomial coefficients and convergence

clc; clear; close all;

set(groot, 'defaulttextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 18);

addpath('Math/NumericalFitSech');
addpath('Math/NumericalFitSech2');
addpath('Math/NumericalFitTanh');
addpath('Math/NumericalFitTanh2');
addpath('Analysis');


%% Analyze the hyperbolic secant

% ----------------------------------------------------------------------
% Plot an approximation with 9 coefficients on (-3, 3)
% ----------------------------------------------------------------------
big_n = 9;
r_fit = 3;
dx = 0.001;

sech_numerical_partial_sum_handle = ...
    @(big_n, x) ComputeNumericalNthPartialSumSech(big_n, r_fit, dx, x);

r_plot = 3.2;

PlotPartialSumComparison( ...
    @sech, sech_numerical_partial_sum_handle, ...
    big_n, r_plot, ...
    '$$x$$', ...
    'True and approx. $$\mathrm{sech}(x)$$ fit on $$(-3, 3)$$');

% ----------------------------------------------------------------------
% Plot on (-6, 6) for approx. made to converge on (-3, 3)
% ----------------------------------------------------------------------
big_n_max = 40;
r_plot = 6;

PlotConvergenceSurface( ...
    @sech, sech_numerical_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in numerical approx. of $$\mathrm{sech}(x)$$ fit on $$(-3, 3)$$');

% ----------------------------------------------------------------------
% Plot on (-pi, pi) for approx. made to converge on (-pi/2, pi/2)
% ----------------------------------------------------------------------
r_fit = pi/2;
dx = 0.001;

sech_numerical_partial_sum_handle = ...
    @(big_n, x) ComputeNumericalNthPartialSumSech(big_n, r_fit, dx, x);

big_n_max = 40;
r_plot = pi;

PlotConvergenceSurface( ...
    @sech, sech_numerical_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in numerical approx. of $$\mathrm{sech}(x)$$ fit on $$\left(-\frac{\pi}{2}, \frac{\pi}{2}\right)$$');

% ----------------------------------------------------------------------
% Plot coefs for numerical expansion made to converge on (-pi/2, pi/2)
% ----------------------------------------------------------------------

big_n = 30;      % The order to use to compute the expanansion
r_fit = pi/2;        % The range to compute the expansion over
dx = 0.00001;    % The numerical dx to use in computing the expansion
big_n_max = 30;  % The maximum approximation order N to plot

sech_numerical_nth_coef_handle = ...
    @(n) ComputeNumericalNthCoefSech(n, big_n, r_fit, dx);

PlotCoefs( ...
    sech_numerical_nth_coef_handle, big_n_max, ...
    'Numerical coefs. for $$\mathrm{sech}(x)$$ fit on $$\left(-\frac{\pi}{2}, \frac{\pi}{2}\right)$$');

% ----------------------------------------------------------------------
% Plot coefs for numerical expansion made to converge on (-4, 4)
% ----------------------------------------------------------------------

big_n = 30;      % The order to use to compute the expanansion
r_fit = 4;       % The range to compute the expansion over
dx = 0.00001;    % The numerical dx to use in computing the expansion
big_n_max = 30;  % The maximum approximation order N to plot

sech_numerical_nth_coef_handle = ...
    @(n) ComputeNumericalNthCoefSech(n, big_n, r_fit, dx);

PlotCoefs( ...
    sech_numerical_nth_coef_handle, big_n_max, ...
    'Numerical coefs. for $$\mathrm{sech}(x)$$ fit on $$(-4, 4)$$');


%% Analyze the hyperbolic tangent

% ----------------------------------------------------------------------
% Plot an approximation with 9 coefficients on (-3, 3)
% ----------------------------------------------------------------------
big_n = 9;
r_fit = 3;
dx = 0.001;

tanh_numerical_partial_sum_handle = ...
    @(big_n, x) ComputeNumericalNthPartialSumTanh(big_n, r_fit, dx, x);

r_plot = 3.2;

PlotPartialSumComparison( ...
    @tanh, tanh_numerical_partial_sum_handle, ...
    big_n, r_plot, ...
    '$$x$$', ...
    'True and approx. $$\mathrm{tanh}(x)$$ fit on $$(-3, 3)$$');

% ----------------------------------------------------------------------
% Plot on (-6, 6) for approx. made to converge on (-3, 3)
% ----------------------------------------------------------------------
big_n_max = 40;
r_plot = 6;

PlotConvergenceSurface( ...
    @tanh, tanh_numerical_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in numerical approx. of $$\mathrm{tanh}(x)$$ fit on $$(-3, 3)$$');

% ----------------------------------------------------------------------
% Plot on (-pi, pi) for approx. made to converge on (-pi/2, pi/2)
% ----------------------------------------------------------------------
r_fit = pi/2;
dx = 0.001;

tanh_numerical_partial_sum_handle = ...
    @(big_n, x) ComputeNumericalNthPartialSumTanh(big_n, r_fit, dx, x);

big_n_max = 40;
r_plot = pi;

PlotConvergenceSurface( ...
    @tanh, tanh_numerical_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in numerical approx. of $$\mathrm{tanh}(x)$$ fit on $$\left(-\frac{\pi}{2}, \frac{\pi}{2}\right)$$');

% ----------------------------------------------------------------------
% Plot coefs for numerical expansion made to converge on (-pi/2, pi/2)
% ----------------------------------------------------------------------

big_n = 30;      % The order to use to compute the expanansion
r_fit = pi/2;    % The range to compute the expansion over
dx = 0.00001;    % The numerical dx to use in computing the expansion
big_n_max = 30;  % The maximum approximation order N to plot

tanh_numerical_nth_coef_handle = ...
    @(n) ComputeNumericalNthCoefTanh(n, big_n, r_fit, dx);

PlotCoefs( ...
    tanh_numerical_nth_coef_handle, big_n_max, ...
    'Numerical coefs. for $$\mathrm{tanh}(x)$$ fit on $$\left(-\frac{\pi}{2}, \frac{\pi}{2}\right)$$');

% ----------------------------------------------------------------------
% Plot coefs for numerical expansion made to converge on (-4, 4)
% ----------------------------------------------------------------------

big_n = 30;      % The order to use to compute the expanansion
r_fit = 4;           % The range to compute the expansion over
dx = 0.00001;    % The numerical dx to use in computing the expansion
big_n_max = 30;  % The maximum approximation order N to plot

tanh_numerical_nth_coef_handle = ...
    @(n) ComputeNumericalNthCoefTanh(n, big_n, r_fit, dx);

PlotCoefs( ...
    tanh_numerical_nth_coef_handle, big_n_max, ...
    'Numerical coefs. for $$\mathrm{tanh}(x)$$ fit on $$(-4, 4)$$');


%% Analyze the hyperbolic secant squared

% ----------------------------------------------------------------------
% Plot an approximation with 9 coefficients on (-3, 3)
% ----------------------------------------------------------------------
big_n = 9;
r_fit = 3;
dx = 0.001;

sech2_numerical_partial_sum_handle = ...
    @(big_n, x) ComputeNumericalNthPartialSumSech2(big_n, r_fit, dx, x);

sech2 = @(x) sech(x).^2;

r_plot = 3.2;

PlotPartialSumComparison( ...
    sech2, sech2_numerical_partial_sum_handle, ...
    big_n, r_plot, ...
    '$$x$$', ...
    'True and approx. $$\mathrm{sech}^2(x)$$ fit on $$(-3, 3)$$');

% ----------------------------------------------------------------------
% Plot on (-6, 6) for approx. made to converge on (-3, 3)
% ----------------------------------------------------------------------
big_n_max = 40;
r_plot = 6;

PlotConvergenceSurface( ...
    sech2, sech2_numerical_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in numerical approx. of $$\mathrm{sech}^2(x)$$ fit on $$(-3, 3)$$');

% ----------------------------------------------------------------------
% Plot on (-pi, pi) for approx. made to converge on (-pi/2, pi/2)
% ----------------------------------------------------------------------
r_fit = pi/2;
dx = 0.001;

sech2_numerical_partial_sum_handle = ...
    @(big_n, x) ComputeNumericalNthPartialSumSech2(big_n, r_fit, dx, x);

big_n_max = 40;
r_plot = pi;

PlotConvergenceSurface( ...
    sech2, sech2_numerical_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in numerical approx. of $$\mathrm{sech}^2(x)$$ fit on $$\left(-\frac{\pi}{2}, \frac{\pi}{2}\right)$$');

% ----------------------------------------------------------------------
% Plot coefs for numerical expansion made to converge on (-pi/2, pi/2)
% ----------------------------------------------------------------------

big_n = 30;      % The order to use to compute the expanansion
r_fit = pi/2;    % The range to compute the expansion over
dx = 0.00001;    % The numerical dx to use in computing the expansion
big_n_max = 30;  % The maximum approximation order N to plot

sech2_numerical_nth_coef_handle = ...
    @(n) ComputeNumericalNthCoefSech2(n, big_n, r_fit, dx);

PlotCoefs( ...
    sech2_numerical_nth_coef_handle, big_n_max, ...
    'Numerical coefs. for $$\mathrm{sech}^2(x)$$ fit on $$\left(-\frac{\pi}{2}, \frac{\pi}{2}\right)$$');

% ----------------------------------------------------------------------
% Plot coefs for numerical expansion made to converge on (-4, 4)
% ----------------------------------------------------------------------

big_n = 30;      % The order to use to compute the expanansion
r_fit = 4;       % The range to compute the expansion over
dx = 0.00001;    % The numerical dx to use in computing the expansion
big_n_max = 30;  % The maximum approximation order N to plot

sech2_numerical_nth_coef_handle = ...
    @(n) ComputeNumericalNthCoefSech2(n, big_n, r_fit, dx);

PlotCoefs( ...
    sech2_numerical_nth_coef_handle, big_n_max, ...
    'Numerical coefs. for $$\mathrm{sech}^2(x)$$ fit on $$(-4, 4)$$');


%% Analyze the hyperbolic tangent squared

% ----------------------------------------------------------------------
% Plot an approximation with 9 coefficients on (-3, 3)
% ----------------------------------------------------------------------
big_n = 9;
r_fit = 3;
dx = 0.001;

tanh2_numerical_partial_sum_handle = ...
    @(big_n, x) ComputeNumericalNthPartialSumTanh2(big_n, r_fit, dx, x);

tanh2 = @(x) tanh(x).^2;

r_plot = 3.2;

PlotPartialSumComparison( ...
    tanh2, tanh2_numerical_partial_sum_handle, ...
    big_n, r_plot, ...
    '$$x$$', ...
    'True and approx. $$\mathrm{tanh}^2(x)$$ fit on $$(-3, 3)$$');

% ----------------------------------------------------------------------
% Plot on (-6, 6) for approx. made to converge on (-3, 3)
% ----------------------------------------------------------------------
big_n_max = 40;
r_plot = 6;

PlotConvergenceSurface( ...
    tanh2, tanh2_numerical_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in numerical approx. of $$\mathrm{tanh}^2(x)$$ fit on $$(-3, 3)$$');

% ----------------------------------------------------------------------
% Plot on (-pi, pi) for approx. made to converge on (-pi/2, pi/2)
% ----------------------------------------------------------------------
r_fit = pi/2;
dx = 0.001;

tanh2_numerical_partial_sum_handle = ...
    @(big_n, x) ComputeNumericalNthPartialSumTanh2(big_n, r_fit, dx, x);

big_n_max = 40;
r_plot = pi;

PlotConvergenceSurface( ...
    tanh2, tanh2_numerical_partial_sum_handle, ...
    big_n_max, r_plot, ...
    '$$x$$', ...
    'Error in numerical approx. of $$\mathrm{tanh}^2(x)$$ fit on $$\left(-\frac{\pi}{2}, \frac{\pi}{2}\right)$$');

% ----------------------------------------------------------------------
% Plot coefs for numerical expansion made to converge on (-pi/2, pi/2)
% ----------------------------------------------------------------------

big_n = 30;      % The order to use to compute the expanansion
r_fit = pi/2;    % The range to compute the expansion over
dx = 0.00001;    % The numerical dx to use in computing the expansion
big_n_max = 30;  % The maximum approximation order N to plot

tanh2_numerical_nth_coef_handle = ...
    @(n) ComputeNumericalNthCoefTanh2(n, big_n, r_fit, dx);

PlotCoefs( ...
    tanh2_numerical_nth_coef_handle, big_n_max, ...
    'Numerical coefs. for $$\mathrm{tanh}^2(x)$$ fit on $$\left(-\frac{\pi}{2}, \frac{\pi}{2}\right)$$');

% ----------------------------------------------------------------------
% Plot coefs for numerical expansion made to converge on (-4, 4)
% ----------------------------------------------------------------------

big_n = 30;      % The order to use to compute the expanansion
r_fit = 4;       % The range to compute the expansion over
dx = 0.00001;    % The numerical dx to use in computing the expansion
big_n_max = 30;  % The maximum approximation order N to plot

tanh2_numerical_nth_coef_handle = ...
    @(n) ComputeNumericalNthCoefTanh2(n, big_n, r_fit, dx);

PlotCoefs( ...
    tanh2_numerical_nth_coef_handle, big_n_max, ...
    'Numerical coefs. for $$\mathrm{tanh}^2(x)$$ fit on $$(-4, 4)$$');
