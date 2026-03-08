%% Main Driver: Test Matrix Fourier Series Coefficients

clc; clear; close all;

set(0, 'defaultTextInterpreter', 'latex');

addpath('./Math');
addpath('./Math/AmplitudeSweepMatrix/');
addpath('./Math/FourierSeries');
addpath('./Math/FourierSeriesTanhAnalytic/');
addpath('./Math/FourierSeriesTanhMatrix/');
addpath('./Math/FourierSeriesTanhSymbolic/')
addpath('./Math/Matrix/');
addpath('./Math/PeakToPeakAnalytic/');
addpath('./Math/PolynomialTheorems/');
addpath('./Math/TanhExpansion');
addpath('./Math/Utils/');
addpath('./Visualization/');


%% Algorithm hyperparameters

fprintf('Initializing Hyperparameters...\n');

number_fourier_coefs_n = 15;
number_partial_sum_terms_ns = 20;
epsilon = 0.0001;
safety_factor = 1.3;
numerical_integral_flag = true;
new_alpha_coefs = true;
max_expected_activation_input_v = 4;

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

new_kappa_inv_flag = false;
min_amplitude_sweep = 0;
max_amplitude_sweep = 4;
num_interogation_points_multiplier = 1;

% Input layer weights
w10_layer0 = 0;
w11_layer0 = 1;

% Hidden layer weights
w10_layer1 = 0;
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
    
    save('alpha_coefs.mat');
    
    fprintf('Computed new alpha coefficients.\n');

else
    
    load('alpha_coefs.mat');
    fprintf('Loaded alpha coefficients.\n');

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


%% Test Polynomial Output Form I

fprintf('\nComputing network output with Polynomial Form I...\n');

y_polynomial_form_i = ComputePolynomialNetworkOutputFormI( ...
    x_hat_normalized_input, alpha_coefs, ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    number_partial_sum_terms_ns);

figure;
plot(psi, y_neuron_output, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_polynomial_form_i, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('True System Output and Polynomial Form I Output');
legend('True', 'Approximation');
grid on;
grid minor;

fprintf('Computed polynomial output via Form I.\n');


%% Test Polynomial Output Form II

fprintf('\nComputing network output with Polynomial Form II...\n');

y_polynomial_form_ii = ComputePolynomialNetworkOutputFormII( ...
    x_hat_normalized_input, alpha_coefs, ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    number_partial_sum_terms_ns);

figure;
plot(psi, y_neuron_output, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_polynomial_form_ii, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('True System Output and Polynomial Form II Output');
legend('True', 'Approximation');
grid on;
grid minor;

fprintf('Computed polynomial output via Form II.\n');


%% Test Analytic Fourier Series Form I

fprintf('\nComputing Fourier Series Output via Form I...\n');

[a_form_i, b_form_i, c_form_i, n_form_i] = ...
    ComputeAnalyticFourierSeriesTanhFormI( ...
        gamma10_layer0, gamma11_layer0, ...
        gamma10_layer1, gamma11_layer1, ...
        alpha_coefs, number_partial_sum_terms_ns, ...
        omega, number_fourier_coefs_n);
    
y_analytic_fourier = ...
    ComputeReconstructedFunctionFromFourierSeries( ...
        a_form_i, b_form_i, n_form_i, psi);

figure;
plot(psi, y_neuron_output, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_analytic_fourier, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('True System Output and Form I Fourier Series Output');
grid on;
grid minor;

figure('Renderer', 'painters', 'Position', [100 100 1100 500]);
subplot(211);
hb1 = bar(n_numerical_method, [a_numerical_method' a_form_i']);
xlabel('n');
ylabel('a');
grid on;
grid minor;
xticks(min(n_numerical_method):max(n_numerical_method));
title('Fourier Harmonics Equation Form I');
set(hb1(1), 'FaceColor','b');
set(hb1(2), 'FaceColor','g');
legend('Numerical', 'Analytical');

subplot(212);
hb2 = bar( ...
    n_numerical_method, [b_numerical_method' b_form_i'], 'k');
xlabel('n');
ylabel('b');
grid on;
grid minor;
xticks(min(n_numerical_method):max(n_numerical_method));
set(hb2(1), 'FaceColor','b');
set(hb2(2), 'FaceColor','g');

fprintf('Computed Fourier Series Output via Form I.\n');


%% Test Analytic Fourier Series Form II

fprintf('\nComputing Fourier Series Output via Form II...\n');

[a_form_ii, b_form_ii, c_form_ii, n_form_ii] = ...
    ComputeAnalyticFourierSeriesTanhFormII( ...
        gamma10_layer0, gamma11_layer0, ...
        gamma10_layer1, gamma11_layer1, ...
        alpha_coefs, number_partial_sum_terms_ns, ...
        omega, number_fourier_coefs_n);
    
y_analytic_fourier = ...
    ComputeReconstructedFunctionFromFourierSeries( ...
        a_form_ii, b_form_ii, n_form_ii, psi);

figure;
plot(psi, y_neuron_output, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_analytic_fourier, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('True System Output and Form II Fourier Series Output');
grid on;
grid minor;

figure('Renderer', 'painters', 'Position', [100 100 1100 500]);
subplot(211);
hb1 = bar(n_numerical_method, [a_numerical_method' a_form_ii']);
xlabel('n');
ylabel('a');
grid on;
grid minor;
xticks(min(n_numerical_method):max(n_numerical_method));
title('Fourier Harmonics Equation Form II');
set(hb1(1), 'FaceColor','b');
set(hb1(2), 'FaceColor','g');
legend('Numerical', 'Analytical');

subplot(212);
hb2 = bar( ...
    n_numerical_method, [b_numerical_method' b_form_ii'], 'k');
xlabel('n');
ylabel('b');
grid on;
grid minor;
xticks(min(n_numerical_method):max(n_numerical_method));
set(hb2(1), 'FaceColor','b');
set(hb2(2), 'FaceColor','g');

fprintf('Computed Fourier Series Output via Form II.\n');


%% Test the peak amplitude formulas

y_peak_numerical = max(y_neuron_output);
y_trough_numerical = min(y_neuron_output);
a_peak_to_peak_numerical = y_peak_numerical - y_trough_numerical;

y_peak_analytic = ComputeYPeakAnalytic( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns);

y_trough_analytic = ComputeYTroughAnalytic( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns);

a_peak_to_peak_analytic = ComputeAPeakToPeakAnalytic( ...
    gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns);


figure;
plot(psi, y_neuron_output, 'linewidth', 2, 'color', 'b');
hold on;
plot(pi/2, y_peak_analytic, 'rx', 'MarkerSize', 10);
plot(3*pi/2, y_trough_analytic, 'kx', 'MarkerSize', 10);
plot(pi/2, y_peak_numerical, 'ro', 'MarkerSize', 10);
plot(3*pi/2, y_trough_numerical, 'ko', 'MarkerSize', 10);
line( ...
    [pi/2 pi/2], ...
    [y_trough_analytic y_trough_analytic+a_peak_to_peak_analytic], ...
    'color', 'k');
line( ...
    [3*pi/2 3*pi/2], ...
    [y_trough_analytic y_trough_analytic+a_peak_to_peak_analytic], ...
    'color', 'k');

xlabel('$$\psi$$');
ylabel('$$y(\psi)$$');
title('True System Output with Peaks and Troughs Identified');
grid on;
grid minor;


%% Interrogate the system through amplitude sweep

% Determine an amplitude sweep
number_interrogation_points_big_p = ...
    number_partial_sum_terms_ns*(number_partial_sum_terms_ns + 1);

amplitude_sweep_vector_big_a = linspace( ...
    min_amplitude_sweep, ...
    max_amplitude_sweep, ...
    num_interogation_points_multiplier*number_interrogation_points_big_p);

% Precompute the Big Ibn Matrix for one fourier harmonic
fourier_number = 1;

%load('b_sweep_true');

big_i_bn_matrix = ConstructBigIbnMatrix( ...
    number_fourier_coefs_n, number_partial_sum_terms_ns, omega);

big_kappa = ComputeBigKappaMatrix( ...
    number_partial_sum_terms_ns, number_interrogation_points_big_p, ...
    big_i_bn_matrix, alpha_coefs, amplitude_sweep_vector_big_a);

shin_vector = ComputeShinVector( ...
    number_partial_sum_terms_ns, w10_layer0, w11_layer0, w11_layer1);

% Compute amplitude of first fourier harmonic wrt. A
% b_sweep_true = zeros(number_interrogation_points_big_p, 1);
% for p = 1:number_interrogation_points_big_p
%     big_a = amplitude_sweep_vector_big_a(p);
%     b_sweep_true(p) = ComputeBnFormI( ...
%         gamma10_layer0, big_a*w11_layer0, gamma11_layer1, ...
%         alpha_coefs, number_partial_sum_terms_ns, fourier_number, omega);
%     fprintf('Computing %i/%i\n', p, number_interrogation_points_big_p);
% end


%% Analyze results attempt to invert through linear algebra

skip_linear_algebra = false;

if ~skip_linear_algebra

    b_sweep_kappa_matrix = big_kappa*shin_vector;

    %figure;
    %plot(amplitude_sweep_vector_big_a, b_sweep_true, 'x');
    %hold on;
    %plot(amplitude_sweep_vector_big_a, b_sweep_kappa_matrix, 'o');

    if new_kappa_inv_flag == true
        kappa_inv_comp = shin_vector*pinv(b_sweep_kappa_matrix);
        save('kappa_inv_comp.mat', 'kappa_inv_comp');
        fprintf('Saved new kappa inverse...\n')
    else
        load('kappa_inv_comp.mat');
        fprintf('Loaded precomputed kappa inverse computed...\n')
    end

    figure;
    imshow(big_kappa);
    title('Big Kappa');

    figure;
    imshow(kappa_inv_comp);
    title('Big Kappa Inverse');

    %shin_vector_approx = ComputeSVDInverse(big_kappa)*b_sweep_kappa_matrix;
    shin_vector_approx_inv = kappa_inv_comp*b_sweep_kappa_matrix;

    figure;
    plot(shin_vector(1:20), 'bx')
    hold on;
    plot(shin_vector_approx_inv(1:20), 'ro')
    title('Shin Vectors - via Matrix Inverse')

    figure;
    plot(log10(abs(shin_vector - shin_vector_approx_inv)), 'x')
    title('Shin Vector Errors - via Matrix Inverse')

end

%% Analyze results and attempt to invert via RREF

augmented_system = [big_kappa b_sweep_kappa_matrix];

reduced_system = rref(augmented_system);

shin_vector_rref = reduced_system(:,end);

figure;
plot(log10(abs(shin_vector - shin_vector_rref)), 'x')
title('Shin Vector Errors - via RREF')

figure;
plot(shin_vector(1:10), 'o');
hold on
plot(shin_vector_rref(1:10), 'x');
title('Shin Vectors - via RREF');

sum(shin_vector)
sum(shin_vector_rref)


%% Analyze reslts and attempt to invert via LSQR

shin_vector_lsqr = lsqr(big_kappa, b_sweep_kappa_matrix);

figure;
semilogy(abs(shin_vector - shin_vector_lsqr), 'x')
title('Shin Vector Errors - via LSQR')

figure;
plot(log10(abs(shin_vector)), 'o');
hold on
%plot(log10(abs(shin_vector_lsqr)), 'x');
title('Shin Vectors - via LSQR');


%% Analyze reslts and attempt to invert via NLSQ

epsilon_function = @(shin_vector_arg) big_kappa*shin_vector_arg - b_sweep_kappa_matrix;

shin_init = ones(size(shin_vector));

shin_vector_nlsq = lsqnonlin(epsilon_function, shin_init);

figure;
semilogy(abs(shin_vector - shin_vector_nlsq), 'x')
title('Shin Vector Errors - via NLSQ');

figure;
plot(log10(abs(shin_vector)), 'o');
hold on
plot(log10(abs(shin_vector_nlsq)), 'x');
title('Shin Vectors - via NLSQ');