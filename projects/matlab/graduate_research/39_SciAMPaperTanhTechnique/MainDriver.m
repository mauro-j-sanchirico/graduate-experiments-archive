%% Hyperbolic Tangent Paper
%% Analysis for Hyperbolic Tangnet Paper

clc; clear; close all;

set(groot, 'DefaultTextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 12);

addpath('./Analysis/');
addpath('./Math/');
addpath('./Math/Matrix/');
addpath('./Math/PolynomialNumericalLinearAlgebra/');
addpath('./Math/PolynomialSystems/');
addpath('./Math/PolynomialTools/');
addpath('./Math/RhoTableBuilder/');
addpath('./Math/SinTaylorExpansion/');
addpath('./Math/TanhSumExpExpansion/');
addpath('./Math/TanhTaylorExpansion/');
addpath('./Math/TanhModifiedExpansion/');
addpath('./Math/TanhNumericalexpansion/');
addpath('./MLP/');
addpath('./SpringModels/');
addpath('./Visualization/');


%% 1) General form of hyperbolic tangent nonlinearies



%% 2) Prepare and analyze several methods of Expansion

% ------------------------------------------------------------------------
% 2.1) Taylor
% ------------------------------------------------------------------------

% Taylor params
number_terms_taylor = 10;

% Compute Taylor coefs
poly_coefs_tanh_taylor = ...
    GetPolynomialCoefsTanhTaylorSeries(number_terms_taylor);

% Visualize and compare results
dv = 1e-3;
v = -pi/2:dv:pi/2;
y_tanh_taylor_series = polyval(poly_coefs_tanh_taylor, v);
y_tanh = tanh(v);
VisualizeTanhTaylorExpansion(v, y_tanh, y_tanh_taylor_series);

% ------------------------------------------------------------------------
% 2.2) Sum of exponentials
% ------------------------------------------------------------------------

% Sum of exponentials params
l_index_max = 4;
m_index_max = 150;

% Sum of exponentials coefs
poly_coefs_tanh_sum_exp = GetPolynomialCoefsTanhSumExp( ...
    m_index_max, l_index_max);

% Visualize and compare results
dv = 1e-3;
v = -4.5:dv:4.5;
y_tanh_sum_exp = sign(v).*polyval(poly_coefs_tanh_sum_exp, abs(v));
y_tanh = tanh(v);
VisualizeTanhSumExponentialsExpansion(v, y_tanh, y_tanh_sum_exp);

% ------------------------------------------------------------------------
% 2.3a) Numerical - full
% ------------------------------------------------------------------------

% Numerical expansion params
dv = 1e-3;
vmin = -4;
vmax = 4;
n_coefs = 60;
fit_type = 'full';

% Numerical expansion
poly_coefs_tanh_numerical = ...
    ComputeTanhNumericalCoefs(dv, vmin, vmax, n_coefs, fit_type);

% Visualize and compare results
v = -4.3:dv:4.3;
y_tanh_numerical = polyval(poly_coefs_tanh_numerical, v);
y_tanh = tanh(v);
VisualizeTanhNumericalExpansion(v, y_tanh, y_tanh_numerical);

% Numerical expansion info:
num_points = length(vmin:dv:vmax)
v_matrix = ConstructVandermondeMatrix( ...
    tanh(vmin:dv:vmax), n_coefs-1, fit_type);

% ------------------------------------------------------------------------
% 2.3a) Numerical - odd powers only
% ------------------------------------------------------------------------

% Numerical expansion params
dv = 1e-5;
vmin = -4;
vmax = 4;
n_coefs = 60;
fit_type = 'odd';

% Numerical expansion
poly_coefs_tanh_numerical_odd = ...
    ComputeTanhNumericalCoefs(dv, vmin, vmax, n_coefs, fit_type);

% Visualize and compare results
v = -4.3:dv:4.3;
y_tanh_numerical_odd = polyval(poly_coefs_tanh_numerical_odd, v);
y_tanh = tanh(v);
VisualizeTanhNumericalOddExpansion(v, y_tanh, y_tanh_numerical_odd);


%% 3. Modified Expansion

% ------------------------------------------------------------------------
% 3.1) Alternate Taylor series derivation
% ------------------------------------------------------------------------


% ------------------------------------------------------------------------
% 3.2) The cructial modification
% ------------------------------------------------------------------------

VisualizeModifiedExpansionIntegrands();

% ------------------------------------------------------------------------
% 3.3) Determining rho_v
% ------------------------------------------------------------------------

m_index_max = 60;
root_type = 1;
plot_flag = false;
rho_table = BuildRhoTable(m_index_max, root_type, plot_flag);

% ------------------------------------------------------------------------
% 3.4) Modified expansion results
% ------------------------------------------------------------------------

% Modified expansion params
m_index_max = 50; % Maximum exponent in polynomial
epsilon = eps;    % Small number used to compute limits (use machine eps)
dxi = 1e-5;       % Differential used for approximate integrals
max_v = 4.0;      % Maximum expected input
numerical_integral_flag = true; % True - faster than symbolic integrals

% Compute modified expansion coefs
poly_coefs_tanh_modified = GetPolynomialCoefsTanhModifiedExpansion( ...
    m_index_max, epsilon, dxi, max_v, rho_table, numerical_integral_flag);

% Visualize and compare results
dv = 0.00001;
v = -1.75:dv:1.75;
y_tanh_modified = polyval(poly_coefs_tanh_modified, v);
y_tanh = tanh(v);
VisualizeTanhModifiedExpansion(v, y_tanh, y_tanh_modified);


%% 4) Numerical comparison

% ------------------------------------------------------------------------
% Coefs comparison
% ------------------------------------------------------------------------

% Recompute Taylor with more terms
number_terms_taylor = 50;
poly_coefs_tanh_taylor = ...
    GetPolynomialCoefsTanhTaylorSeries(number_terms_taylor);

m_index_max = 50;
VisualizeExpansionCoefs( ...
    poly_coefs_tanh_taylor, poly_coefs_tanh_sum_exp, ...
    poly_coefs_tanh_numerical, poly_coefs_tanh_numerical_odd, ...
    poly_coefs_tanh_modified, m_index_max);

% ------------------------------------------------------------------------
% Convergence plots
% ------------------------------------------------------------------------
do_convergence_analysis = false;

if do_convergence_analysis
    PlotConvergenceSurfaces();
end


%% 5.1a) Neural network hidden weight deduction - Prep

w0_layer1 = 0.8;
w1_layer1 = 1.5;
w0_layer0 = -0.2;
w1_layer0 = 0.5;

% ------------------------------------------------------------------------
% Get test stimuli and measured responses
% ------------------------------------------------------------------------
x_stimulus = [-2, -1, 1, 2];
x_zero = 0;

y_response = EvalFundamentalMLP( ...
    w0_layer1, w1_layer1, w0_layer0, w1_layer0, x_stimulus);
y_zero = EvalFundamentalMLP( ...
    w0_layer1, w1_layer1, w0_layer0, w1_layer0, x_zero);

% ------------------------------------------------------------------------
% Get the alpha coefficients
% ------------------------------------------------------------------------

m_index_max = 3;  % Maximum exponent in polynomial
root_type = 1;     % 1 = Use root with largest real part
plot_flag = false; % Don't make plots when building rho table
rho_table = BuildRhoTable(m_index_max, root_type, plot_flag);
epsilon = eps;     % Small number used to compute limits (use machine eps)
dxi = 1e-4;        % Differential used for approximate integrals
max_v = 3.0;       % Maximum expected input
numerical_integral_flag = true; % True - faster than symbolic integrals

% Compute modified expansion coefs
alpha_coefs = GetPolynomialCoefsTanhModifiedExpansion( ...
    m_index_max, epsilon, dxi, max_v, rho_table, numerical_integral_flag);


%% 5.1b) Neural network hidden weight deduction - execution

% ------------------------------------------------------------------------
% Build a polynomial system from the test points
% ------------------------------------------------------------------------
y_model_stimulus = EvalFundamentalMLPPolynomial( ...
    w0_layer1, w1_layer1, w0_layer0, w1_layer0, x_stimulus, alpha_coefs);

y_model_zero = EvalFundamentalMLPPolynomial( ...
    w0_layer1, w1_layer1, w0_layer0, w1_layer0, x_zero, alpha_coefs);

figure;
plot(x_stimulus, y_response);
hold on;
plot(x_stimulus, y_model_stimulus);
title('Response to Stimulus');

% ------------------------------------------------------------------------
% Generate the polynomial systems to be solved
% ------------------------------------------------------------------------

syms w0_layer1_sym w1_layer1_sym w0_layer0_sym w1_layer0_sym
syms x1 x2 x3 x4

fund_sym_polysys = EvalFundamentalMLPPolynomial( ...
    w0_layer1_sym, w1_layer1_sym, w0_layer0_sym, w1_layer0_sym, ...
    x_stimulus, alpha_coefs) - y_response;

zero_sym_polysys = EvalFundamentalMLPPolynomial( ...
    w0_layer1_sym, w1_layer1_sym, w0_layer0_sym, w1_layer0_sym, ...
    x_zero, alpha_coefs) - y_zero;

fund_polysys = ConvertFundamentalMLPToPolynomialSystem( ...
    x_stimulus, y_response, alpha_coefs);

zero_polysys = ConvertZeroFundamentalMLPToPolynomialSystem( ...
    x_zero, y_zero, alpha_coefs);

% ------------------------------------------------------------------------
% Solve some of the systems with groebner basis
% ------------------------------------------------------------------------
fprintf('Gbasis of zero polysys:\n');
gbasis_zero_polysys = gbasis(zero_sym_polysys)

fprintf('Gbasis of fund polysys:\n');
tic
gbasis_fund_polysys = gbasis( ...
    fund_sym_polysys, ...
    [w0_layer1_sym, w1_layer1_sym, w0_layer0_sym, w1_layer0_sym])
toc

%%
% ------------------------------------------------------------------------
% Solve some of the systems analytically
% ------------------------------------------------------------------------
fprintf('Find a solution of zero polysys:\n')
zero_sym_roots_eq = vpasolve( ...
    zero_sym_polysys == y_zero, ...
    [w0_layer1_sym, w1_layer1_sym, w0_layer0_sym], ...
    [w0_layer1, w1_layer1, w0_layer0]);

w0_layer0_sol = zero_sym_roots_eq.w0_layer0_sym
w0_layer1_sol = zero_sym_roots_eq.w0_layer1_sym
w1_layer1_sol = zero_sym_roots_eq.w1_layer1_sym


%% 5.2) Nonlinear circuit analysis


%% 5.3) Spring model identification

dx = 0.01;
dk = 0.2;
kmin = 0.2;
kmax = 2;
x_distance_linear = -3:dx:3;
k_spring_const = [kmin:dk:kmax]';

f_linear_spring = k_spring_const*x_distance_linear;
f_nonlinear_spring = tanh(k_spring_const*x_distance_linear);

VisualizeLinearAndNonlinearSpringForce( ...
    x_distance_linear, f_linear_spring, ...
    f_nonlinear_spring, k_spring_const);


%% The ODEs

k_spring_const = [0.2:0.2:4]';
dt = 0.01;
tspan = 0:dt:10;
x0_init_conditions = [0 1];

t_linear = cell(length(k_spring_const));
x_distance_linear = cell(length(k_spring_const));

t_nonlinear = cell(length(k_spring_const));
x_distance_nonlinear = cell(length(k_spring_const));

% Simulate a family of linear springs
for idx = 1:length(k_spring_const)
    linear_spring_handle = @(t, x_states) GetLinearSpringState( ...
        t, x_states, k_spring_const(idx));

    [t_linear{idx}, x_distance_linear{idx}] = ode45( ...
        linear_spring_handle, tspan, x0_init_conditions);
end

% Simulate a family of nonlinear springs
for idx = 1:length(k_spring_const)
    nonlinear_spring_handle = @(t, x_states) GetNonlinearSpringState( ...
        t, x_states, k_spring_const(idx));

    [t_nonlinear{idx}, x_distance_nonlinear{idx}] = ode45( ...
        nonlinear_spring_handle, tspan, x0_init_conditions);
end

VisualizeLinearAndNonlinearSpringPosition( ...
    t_linear, x_distance_linear, t_nonlinear, x_distance_nonlinear, ...
    k_spring_const)



