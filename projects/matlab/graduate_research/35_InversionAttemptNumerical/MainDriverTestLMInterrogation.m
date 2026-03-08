%% Main Driver: Test Levenberg-Marquardt Interrogation Algorithm
%% Applies Levenberg-Marquardt optimization to identify weights

clc; clear; close all;

set(0, 'defaultTextInterpreter', 'latex');

rng(1);

addpath('./Math');
addpath('./Math/AmplitudeSweepMatrix/');
addpath('./Math/FourierSeries');
addpath('./Math/FourierSeriesTanhAnalytic/');
addpath('./Math/FourierSeriesTanhMatrix/');
addpath('./Math/FourierSeriesTanhSymbolic/');
addpath('./Math/Matrix/');
addpath('./Math/NonlinearInterrogation/');
addpath('./Math/PeakToPeakAnalytic/');
addpath('./Math/PolynomialTheorems/');
addpath('./Math/TanhExpansion');
addpath('./Math/Utils/');
addpath('./Visualization/');


%% Algorithm hyperparameters

fprintf('Initializing Hyperparameters...\n');

% Expansions:
number_fourier_coefs_n = 10;
number_partial_sum_terms_ns = 20;

% Numerical parameters
epsilon = 0.0001;
safety_factor = 1.3;
max_expected_activation_input_v = 4;

% Options
numerical_integral_flag = true;
new_alpha_coefs = true;
new_big_i_matricies = true;

% Interrogation Signals
min_amplitude_sweep = 0;
max_amplitude_sweep = 2;
number_interrogation_points_big_p = [];

fprintf('Number of Fourier Coefficients: %i\n', number_fourier_coefs_n);
fprintf('Number of partial sum terms: %i\n', number_partial_sum_terms_ns);

fprintf('Initialized.\n')


%% Accessible Information

fprintf('\nSetting accessible information...\n')

% Independent variable
omega = 1;
dt = 0.0001;
t = 0:dt:2*pi/omega;
psi = omega*t;

% Input gain
big_a1 = 1;

% Input signal
x_hat_normalized_input = sin(psi);

fprintf('Set accessible parameters.\n');

figure;
plot(psi, x_hat_normalized_input, 'linewidth', 2, 'color', 'b');
xlabel('$$\psi$$');
ylabel('$$\hat{x}(\psi)$$');
title('Normalized System Input');
xlim([min(psi) max(psi)]);
ylim([1.1*min(x_hat_normalized_input) 1.1*max(x_hat_normalized_input)]);
grid on;
grid minor;

fprintf('Displayed Visualization.\n');


%% Hidden information

fprintf('\nSetting hidden information...\n')

% Biases
big_a0 = 1;

% Input layer weights
w10_layer0 = 0.5;
w11_layer0 = 0.9;

% Hidden layer weights
w10_layer1 = -0.2;
w11_layer1 = 1;

% System input layer gains
gamma10_layer0 = w10_layer0*big_a0;
gamma11_layer0 = w11_layer0*big_a1;

% System hidden layer gains
gamma10_layer1 = w10_layer1*big_a0;
gamma11_layer1 = w11_layer1;

fprintf('gamma10_layer0 = %f\n', gamma10_layer0);
fprintf('gamma10_layer0 = %f\n', gamma11_layer0);
fprintf('gamma11_layer1 = %f\n', gamma10_layer1);
fprintf('gamma11_layer1 = %f\n\n', gamma11_layer1);

fprintf('w10_layer0 = %f\n', w10_layer0);
fprintf('w10_layer0 = %f\n', w11_layer0);
fprintf('w11_layer1 = %f\n', w10_layer1);
fprintf('w11_layer1 = %f\n', w11_layer1);

% Activation input first layer
v1_layer0 = gamma10_layer0 + gamma11_layer0*x_hat_normalized_input;

% First layer activation
x_layer1 = tanh(v1_layer0);

% Activation input second layer
v1_layer1 = gamma10_layer1 + gamma11_layer1*x_layer1;

% Second layer activation
y_neuron_output = v1_layer1;

fprintf('Set hidden parameters.\n')

figure;
plot(psi, y_neuron_output, 'linewidth', 2, 'color', 'b');
xlabel('$$\psi$$');
ylabel('$$y(\psi)$$');
title('True System Output');
grid on;
grid minor;


%% Get the alpha coefficients

fprintf('\nPrecomputing alpha coefficients...\n');

if new_alpha_coefs
    
    % We always use a safety factor when computing max_v to avoid
    % underestimating it
    max_v = safety_factor*max_expected_activation_input_v;

    alpha_coefs = ComputeAlphaExpansionCoefs( ...
        number_partial_sum_terms_ns, epsilon, ...
        max_v, numerical_integral_flag);
    
    save('alpha_coefs.mat', 'alpha_coefs');
    
    fprintf('Computed new alpha coefficients.\n');

else
    
    load('alpha_coefs.mat');
    fprintf('Loaded alpha coefficients.\n');

end


%% Get the Big I Matricies

if new_big_i_matricies
    
    big_i_a0_vector = ConstructBigIa0Vector( ...
        number_partial_sum_terms_ns, omega);
    
    save('big_i_a0_vector.mat', 'big_i_a0_vector');

    big_i_an_matrix = ConstructBigIanMatrix( ...
        number_fourier_coefs_n, number_partial_sum_terms_ns, omega);
    
    save('big_i_an_matrix.mat', 'big_i_an_matrix');

    big_i_bn_matrix = ConstructBigIbnMatrix( ...
        number_fourier_coefs_n, number_partial_sum_terms_ns, omega);
    
    save('big_i_bn_matrix.mat', 'big_i_bn_matrix');
    fprintf('Saved new I matricies.\n')

else
    
    load('big_i_a0_vector.mat');
    load('big_i_an_matrix.mat');
    load('big_i_bn_matrix.mat');
    fprintf('Loaded I matricies.\n');

end


%% Test the validity of the alpha coefficients

fprintf('\nTesting range of validity of alpha coefficients...\n');

v = -max_expected_activation_input_v:0.1:max_expected_activation_input_v;
y_approx = EvaluateTanh(v, alpha_coefs, number_partial_sum_terms_ns);
y_true = tanh(v);

figure;
plot(v, y_true, 'linewidth', 6, 'color', 'b');
hold on;
plot(v, y_approx, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('True System Output and Hyperbolic Tangent Approximation Output');
legend('Truth', 'Approximation');
grid on;
grid minor;

fprintf('Displayed visualization.\n');


%% Compute the Neuron Output and Fourier Series Numerically

fprintf('\nComputing Fourier Series output numerically...\n');

[a_numerical_method, b_numerical_method, ...
 c_numerical_method, n_numerical_method] = ...
    ComputeNumericalFourierSeries( ...
        psi, y_neuron_output, number_fourier_coefs_n);

y_numerical_fourier = ...
    ComputeReconstructedFunctionFromFourierSeries( ...
        a_numerical_method, b_numerical_method, n_numerical_method, psi);

figure;
plot(psi, y_neuron_output, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_numerical_fourier, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('True System Output and Numerical Fourier Series Output');
grid on;
grid minor;

figure('Renderer', 'painters', 'Position', [100 100 1100 500]);
subplot(211);
bar(n_numerical_method, a_numerical_method);
xticks(min(n_numerical_method):max(n_numerical_method));
xlabel('$$n$$');
ylabel('$$a$$');
grid on;
grid minor;
title('Fourier Harmonics');

subplot(212);
bar(n_numerical_method, b_numerical_method);
xticks(min(n_numerical_method):max(n_numerical_method));
xlabel('$$n$$');
ylabel('$$b$$');
grid on;
grid minor;

fprintf('Computed Fourier Series output numerically.\n');


%% Interrogate the system through amplitude sweep

fprintf('Interrogating via amplitude sweep...\n');

% Determine an amplitude sweep
if isempty(number_interrogation_points_big_p)
    number_interrogation_points_big_p = ...
        number_partial_sum_terms_ns*(number_partial_sum_terms_ns + 1);
end

fprintf('Sweeping amplitude from %i to %i with P=%i points...\n', ...
    min_amplitude_sweep, max_amplitude_sweep, ...
    number_interrogation_points_big_p);

amplitude_sweep_vector_big_a = linspace( ...
    min_amplitude_sweep, ...
    max_amplitude_sweep, ...
    number_interrogation_points_big_p);

big_kappa_a = ComputeBigKappaMatrix( ...
    number_partial_sum_terms_ns, number_interrogation_points_big_p,...
    big_i_an_matrix, alpha_coefs, amplitude_sweep_vector_big_a, ...
    number_fourier_coefs_n);

big_kappa_b = ComputeBigKappaMatrix( ...
    number_partial_sum_terms_ns, number_interrogation_points_big_p,...
    big_i_bn_matrix, alpha_coefs, amplitude_sweep_vector_big_a, ...
    number_fourier_coefs_n);

big_a_matrix = [big_kappa_a; big_kappa_b];

shin_vector = ComputeShinVector( ...
    number_partial_sum_terms_ns, w10_layer0, w11_layer0, w11_layer1);

f_vector_true = big_a_matrix*shin_vector;


%% Use a nonlinear optimizer to recover a single solution for the weights

options = optimoptions( ...
    'lsqnonlin', ...
    'Display', 'iter', ...
    'Algorithm', 'levenberg-marquardt', ...
    'MaxFunctionEvaluations', 100000, ...
    'MaxIterations', 100000);

optfun_handle = @(w_vector_arg)EvaluateWeightsViaMatrixEquations( ...
    w_vector_arg, big_a_matrix, f_vector_true, ...
    number_partial_sum_terms_ns);

w_init_vector = [0.5 0.5 0.5];

lb = [];
ub = [];

weights_lsqnonlin = ...
    lsqnonlin(optfun_handle, w_init_vector, lb, ub, options);

% Measured weights
w10_layer0_meas = weights_lsqnonlin(1);
w11_layer0_meas = weights_lsqnonlin(2);
w10_layer1_meas = 0;
w11_layer1_meas = weights_lsqnonlin(3);

% Measured system input layer gains
gamma10_layer0_meas = w10_layer0_meas*big_a0;
gamma11_layer0_meas = w11_layer0_meas*big_a1;

% Measured system hidden layer gains
gamma10_layer1_meas = w10_layer1_meas*big_a0;
gamma11_layer1_meas = w11_layer1_meas;


%% Try to Compute a Reduced Groebner Basis

shin_vector_meas = ComputeShinVector( ...
    number_partial_sum_terms_ns, ...
    w10_layer0_meas, w11_layer0_meas, w11_layer1_meas);

figure;
semilogy(abs(shin_vector - shin_vector_meas), 'kx');
grid on; grid minor;
title('Error Between Shin Vector True and Measured');
xlabel('Index');
ylabel('Error');

w10_layer0_sym = sym('w10_layer0', 'real');
w11_layer0_sym = sym('w11_layer0', 'real');
w11_layer1_sym = sym('w11_layer1', 'real');

shin_vector_sym =  ComputeShinVectorSym( ...
    number_partial_sum_terms_ns, ...
    w10_layer0_sym, w11_layer0_sym, w11_layer1_sym);

polysys = (shin_vector_sym - shin_vector_meas)';

% Loop through the overdetermined system of polynomials to find a pair of
% three which allows computing a groebner basis which may be solved
% analytically for all possible weight solutions.  Note that this looping
% is needed because computing groebner basis for inexact systems using
% standard algorithms is unreliable.  We take advantage of the fact that
% the system is overdetermined to search for an stably solvable case.

for idx = 3:length(polysys)
    
    idx3 = idx;
    idx2 = idx - 1;
    idx1 = idx - 2;

    groebner_basis = gbasis(polysys([idx1 idx2 idx3]));
    
    % If we found a consistent solution, break
    if groebner_basis ~= 1
        break
    end
end

fprintf( ...
    'Found grobner basis on shin elements %i %i %i:\n', ...
    idx1, idx2, idx3);

groebner_basis'

weight_solutions = solve(groebner_basis);

fprintf('Solved groebner basis for weight space:\n');

double(weight_solutions.w10_layer0)
double(weight_solutions.w11_layer0)
double(weight_solutions.w11_layer1)


%% Compute the output bias

fprintf('Computing bias term from measured weights...\n');

a0_hat = ComputeA0Hat( ...
    gamma10_layer0_meas, gamma11_layer0_meas, gamma11_layer1_meas, ...
    alpha_coefs, number_partial_sum_terms_ns, big_i_a0_vector, omega);

gamma10_layer1_meas = (a_numerical_method(1) - a0_hat)/2;
w10_layer1_meas = gamma10_layer1_meas;


%% Reconstruct the signal with the identified weights

fprintf('\nReconstructing system with parameters...\n')

fprintf('gamma10_layer0 measured = %f\n', gamma10_layer0_meas);
fprintf('gamma10_layer0 measured = %f\n', gamma11_layer0_meas);
fprintf('gamma11_layer1 measured = %f\n', gamma10_layer1_meas);
fprintf('gamma11_layer1 measured = %f\n\n', gamma11_layer1_meas);

fprintf('w10_layer0 measured = %f\n', w10_layer0_meas);
fprintf('w10_layer0 measured = %f\n', w11_layer0_meas);
fprintf('w11_layer1 measured = %f\n', w10_layer1_meas);
fprintf('w11_layer1 measured = %f\n', w11_layer1_meas);

% Activation input first layer
v1_layer0_meas = ...
    gamma10_layer0_meas + gamma11_layer0_meas*x_hat_normalized_input;

% First layer activation
x_layer1_meas = tanh(v1_layer0_meas);

% Activation input second layer
v1_layer1_meas = gamma10_layer1 + gamma11_layer1*x_layer1_meas;

% Second layer activation
y_neuron_output_reconstructed = v1_layer1_meas;

figure;
plot(psi, y_neuron_output, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_neuron_output_reconstructed, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y(\psi)$$');
title('True System Output and Output Reconstructed from Interrogation');
grid on;
grid minor;
