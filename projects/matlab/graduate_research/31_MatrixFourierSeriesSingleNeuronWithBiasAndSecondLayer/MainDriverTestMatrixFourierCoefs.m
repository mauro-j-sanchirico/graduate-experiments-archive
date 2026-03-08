%% Main Driver: Test Matrix Fourier Series Coefficients

clc; clear; close all;

set(0, 'defaultTextInterpreter', 'latex');

addpath('./Math');
addpath('./Math/TanhExpansion');
addpath('./Math/FourierSeries');
addpath('./Math/FourierSeriesTanhAnalytic/');
addpath('./Math/FourierSeriesTanhMatrix/');
addpath('./Math/FourierSeriesTanhSymbolic/')
addpath('./Math/Matrix/');
addpath('./Math/PolynomialSolving/')
addpath('./Math/Utils/');
addpath('./Visualization/');


%% Algorithm hyperparameters

fprintf('Initializing Hyperparameters...\n');

number_fourier_coefs_n = 10;
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
title('Normalized Neuron Input');
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
w11_layer0 = 2;

% Hidden layer weights
w10_layer1 = 0.2;
w11_layer1 = 1;

% System input layer gains
gamma10_layer0 = w10_layer0*big_a0;
gamma11_layer0 = w11_layer0*big_a1;

% System hidden layer gains
gamma10_layer1 = w10_layer1*big_a0;
gamma11_layer1 = w11_layer1;

fprintf('gamma_10_layer0 = %f\n', gamma10_layer0);
fprintf('gamma_10_layer0 = %f\n', gamma11_layer0);
fprintf('gamma_11_layer1 = %f\n', gamma10_layer1);
fprintf('gamma_11_layer1 = %f\n\n', gamma11_layer1);

fprintf('w_10_layer0 = %f\n', w10_layer0);
fprintf('w_10_layer0 = %f\n', w11_layer0);
fprintf('w_11_layer1 = %f\n', w10_layer1);
fprintf('w_11_layer1 = %f\n', w11_layer1);

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
title('True Neuron Output');
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
title('True Neuron Output and Hyperbolic Tangent Output');
grid on;
grid minor;

fprintf('Displayed visualization.\n');


%% Precompute the Design Time Matricies

fprintf('\nPrecomputing the design time matricies...\n');

% Matrix used in equation for a0
big_i_a0_vector = ConstructBigIa0Vector( ...
    number_partial_sum_terms_ns, omega);

[rows_big_i_a0, cols_big_i_a0] = size(big_i_a0_vector);

fprintf('Computed new I_a0 vector of size %i x %i\n', ...
    rows_big_i_a0, cols_big_i_a0);

% Matrix used in equation for an
big_i_an_matrix = ConstructBigIanMatrix( ...
    number_fourier_coefs_n, number_partial_sum_terms_ns, omega);

[rows_big_i_an, cols_big_i_an] = size(big_i_an_matrix);

fprintf('Computed new I_an matrix of size %i x %i\n', ...
    rows_big_i_an, cols_big_i_an);

% Matrix used in equation for bn
big_i_bn_matrix = ConstructBigIbnMatrix( ...
    number_fourier_coefs_n, number_partial_sum_terms_ns, omega);

[rows_big_i_bn, cols_big_i_bn] = size(big_i_bn_matrix);

fprintf('Computed new I_bn matrix of size %i x %i\n', ...
    rows_big_i_bn, cols_big_i_bn);

VisualizeBigIMatricies( ...
    big_i_a0_vector, big_i_an_matrix, big_i_bn_matrix, ...
    number_fourier_coefs_n, number_partial_sum_terms_ns);


%% Compute the Fourier Series and Neuron Output Numerically

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
title('True Neuron Output and Numerical Fourier Series Output');
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


%% Compute the Fourier Series Analytically

fprintf('\nComputing Fourier Series Output analytically...\n');

[a_analytic_method, b_analytic_method, ...
 c_analytic_method, n_analytic_method] = ...
    ComputeAnalyticFourierSeriesTanh( ...
        gamma10_layer0, gamma11_layer0, ...
        gamma10_layer1, gamma11_layer1, ...
        alpha_coefs, number_partial_sum_terms_ns, ...
        omega, number_fourier_coefs_n);
    
y_analytic_fourier = ...
    ComputeReconstructedFunctionFromFourierSeries( ...
        a_analytic_method, b_analytic_method, n_analytic_method, psi);

figure;
plot(psi, y_neuron_output, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_analytic_fourier, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('True Neuron Output and Analytical Fourier Series Output');
grid on;
grid minor;

figure('Renderer', 'painters', 'Position', [100 100 1100 500]);
subplot(211);
hb1 = bar(n_numerical_method, [a_numerical_method' a_analytic_method']);
xlabel('n');
ylabel('a');
grid on;
grid minor;
xticks(min(n_numerical_method):max(n_numerical_method));
title('Fourier Harmonics');
set(hb1(1), 'FaceColor','b');
set(hb1(2), 'FaceColor','g');
legend('Numerical', 'Analytical');

subplot(212);
hb2 = bar( ...
    n_numerical_method, [b_numerical_method' b_analytic_method'], 'k');
xlabel('n');
ylabel('b');
grid on;
grid minor;
xticks(min(n_numerical_method):max(n_numerical_method));
set(hb2(1), 'FaceColor','b');
set(hb2(2), 'FaceColor','g');

fprintf('Computed Fourier Series Output analytically.\n');


%% Compute the Fourier Series via Matrix Equations

fprintf('\nComputing Fourier Series Output via matrix equations.\n')

big_alpha_matrix = ConstructBigAlphaMatrix( ...
    alpha_coefs, number_partial_sum_terms_ns);

[rows_big_alpha, cols_big_alpha] = size(big_alpha_matrix);

fprintf('Computed new A matrix of size %i x %i\n', ...
    rows_big_alpha, cols_big_alpha);

big_g_matrix = ConstructBigGMatrix( ...
    gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
    number_partial_sum_terms_ns);

[rows_big_g, cols_big_g] = size(big_g_matrix);

fprintf('Computed new G matrix of size %i x %i\n', ...
    rows_big_g, cols_big_g);

VisualizeBigAlphaBigGMatricies( ...
    big_alpha_matrix, big_g_matrix, number_partial_sum_terms_ns);

[big_beta_vector_from_matricies, ...
 big_beta_a0_vector_from_matricies] = ...
    ConstructBigBetaVectorsFromMatricies(big_alpha_matrix, big_g_matrix);

[big_beta_vector_from_equations, ...
 big_beta_a0_vector_from_equations] = ...
     ConstructBigBetaVectorFromEquations( ...
        number_partial_sum_terms_ns, ...
        gamma10_layer0, gamma11_layer0, gamma11_layer1, alpha_coefs);

VisualizeAndCompareBigBetaVectors( ...
    number_partial_sum_terms_ns, ...
    big_beta_vector_from_equations, big_beta_vector_from_matricies, ...
    big_beta_a0_vector_from_matricies, big_beta_a0_vector_from_equations);

an_vector = omega/pi*(big_i_an_matrix*big_beta_vector_from_matricies);
bn_vector = omega/pi*(big_i_bn_matrix*big_beta_vector_from_matricies);

a0_matrix_method = ...
    2*gamma10_layer1 ...
  + (omega/pi)*big_i_a0_vector'*big_beta_a0_vector_from_matricies;

a_matrix_method = [a0_matrix_method; an_vector]';
b_matrix_method = [0; bn_vector]';

n_matrix_method = 0:number_fourier_coefs_n;

y_matrix_fourier = ...
    ComputeReconstructedFunctionFromFourierSeries( ...
        a_matrix_method, b_matrix_method, n_matrix_method, psi);

figure;
plot(psi, y_neuron_output, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_matrix_fourier, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('True Neuron Output and Matrix Equation Fourier Series Output');
grid on;
grid minor;

figure('Renderer', 'painters', 'Position', [100 100 1100 500]);
subplot(211);
hb1 = bar(n_numerical_method, [a_numerical_method' a_matrix_method']);
xlabel('$$n$$');
ylabel('$$a$$');
grid on;
grid minor;
xticks(min(n_numerical_method):max(n_numerical_method));
title('Fourier Harmonics');
set(hb1(1), 'FaceColor', 'b');
set(hb1(2), 'FaceColor', 'g');
legend('Numerical', 'Matrix');

subplot(212);
hb2 = bar( ...
    n_numerical_method, [b_numerical_method' b_matrix_method']);
xlabel('$$n$$');
ylabel('$$b$$');
grid on;
grid minor;
xticks(min(n_numerical_method):max(n_numerical_method));
set(hb2(1), 'FaceColor','b');
set(hb2(2), 'FaceColor','g');

fprintf('Computed Fourier Series Output via matricies.\n');


%% Use information gathered at design time to compute I matrix inverses

fprintf( ...
    '\nDeducing inverses of big i matricies using design time info...\n');

% Get the measured Fourier Series coefficients

[a_measured, b_measured, ~, ~] = ComputeNumericalFourierSeries( ...
    psi, y_neuron_output, number_fourier_coefs_n);

% Compute preliminary vectors
a_n_prime_deduced = a_measured(2:end)';
b_n_prime_deduced = b_measured(2:end)';

big_i_an_matrix_inv = ...
    (omega/pi)*big_beta_vector_from_equations*pinv(a_n_prime_deduced);
big_i_bn_matrix_inv = ...
    (omega/pi)*big_beta_vector_from_equations*pinv(b_n_prime_deduced);

fprintf('Computed inverses.\n');


%% Rerun the simulation with new hidden parameters

fprintf('\nSetting new hidden information...\n')

% Biases
big_a0 = 1;

% Input layer weights
w10_layer0 = 1;
w11_layer0 = 1.5;

% Hidden layer weights
w10_layer1 = -0.5;
w11_layer1 = 0.8;

% System input layer gains
gamma10_layer0 = w10_layer0*big_a0;
gamma11_layer0 = w11_layer0*big_a1;

% System hidden layer gains
gamma10_layer1 = w10_layer1*big_a0;
gamma11_layer1 = w11_layer1;

fprintf('gamma_10_layer0 = %f\n', gamma10_layer0);
fprintf('gamma_10_layer0 = %f\n', gamma11_layer0);
fprintf('gamma_11_layer1 = %f\n', gamma10_layer1);
fprintf('gamma_11_layer1 = %f\n\n', gamma11_layer1);

fprintf('w_10_layer0 = %f\n', w10_layer0);
fprintf('w_10_layer0 = %f\n', w11_layer0);
fprintf('w_11_layer1 = %f\n', w10_layer1);
fprintf('w_11_layer1 = %f\n', w11_layer1);

% Activation input first layer
v1_layer0 = gamma10_layer0 + gamma11_layer0*x_hat_normalized_input;

% First layer activation
x_layer1 = tanh(v1_layer0);

% Activation input second layer
v1_layer1 = gamma10_layer1 + gamma11_layer1*x_layer1;

% Second layer activation
y_neuron_output = v1_layer1;

[big_beta_vector_from_equations_new, ...
 big_beta_a0_vector_from_equations_new] = ...
     ConstructBigBetaVectorFromEquations( ...
        number_partial_sum_terms_ns, ...
        gamma10_layer0, gamma11_layer0, gamma11_layer1, alpha_coefs);

fprintf('Set new hidden parameters.\n')

figure;
plot(psi, y_neuron_output, 'linewidth', 2, 'color', 'b');
xlabel('$$\psi$$');
ylabel('$$y(\psi)$$');
title('True Neuron Output');
grid on;
grid minor;


%% Compute the Hidden Parameters from The Fourier Series Naively

fprintf( ...
  '\nAttempting to compute hidden parameters via matrix equations...\n');

% 1) Measure the Fourier Series coefficients
a0_deduced = a_measured(1);

[a_measured, b_measured, c_measured, n_measured] = ...
    ComputeNumericalFourierSeries( ...
        psi, y_neuron_output, number_fourier_coefs_n);

% 2) Compute preliminary vectors
a_n_prime_deduced = a_measured(2:end)';
b_n_prime_deduced = b_measured(2:end)';

% 3) Compute Big Beta vector

big_beta_vector_deduced1 = ...
    (pi/omega)*big_i_an_matrix_inv*a_n_prime_deduced;

big_beta_vector_deduced2 = ...
    (pi/omega)*big_i_an_matrix_inv*a_n_prime_deduced;

figure('Renderer', 'painters', 'Position', [100 100 1100 500]);
subplot(311)
bar_y = [big_beta_vector_deduced2 big_beta_vector_from_equations_new];
hb1 = bar(1:length(big_beta_vector_deduced1), bar_y);
xticks(1:length(big_beta_vector_deduced1));
grid on;
grid minor;
set(hb1(1), 'FaceColor','b');
set(hb1(2), 'FaceColor','g');
title('$$B$$');
legend('Deduced', 'Hidden');

subplot(312)
bar_y = log10(abs( ...
    [big_beta_vector_deduced2 big_beta_vector_from_equations_new]));
hb1 = bar(1:length(big_beta_vector_deduced1), bar_y);
xticks(1:length(big_beta_vector_deduced1));
grid on;
grid minor;
set(hb1(1), 'FaceColor','b');
set(hb1(2), 'FaceColor','g');
title('$$\log_{10}(|B|)$$');

subplot(313)
bar_y = sign( ...
    [big_beta_vector_deduced2 big_beta_vector_from_equations_new]);
hb2 = bar(1:length(big_beta_vector_deduced1), bar_y);
xticks(1:length(big_beta_vector_deduced1));
grid on;
grid minor;
set(hb2(1), 'FaceColor','b');
set(hb2(2), 'FaceColor','g');
title('sign$$(B)$$');

fprintf('Failed to deduce big beta vector.\n');


%% Compute the Symbolic System of Polynomial Equations

fprintf('\nConstructing symbolic polynomial system...\n');

big_alpha_matrix = ConstructBigAlphaMatrix( ...
    alpha_coefs, number_partial_sum_terms_ns);

[rows_big_alpha, cols_big_alpha] = size(big_alpha_matrix);

fprintf('Computed new A matrix of size %i x %i\n', ...
    rows_big_alpha, cols_big_alpha);

gamma10_layer0_sym = sym('x', 'real');
gamma11_layer0_sym = sym('y', 'real');
gamma11_layer1_sym = sym('z', 'real');

big_g_matrix_sym = ConstructBigGMatrixSymbolic( ...
    gamma10_layer0_sym, gamma11_layer0_sym, gamma11_layer1_sym, ...
    number_partial_sum_terms_ns);

[rows_big_g_sym, cols_big_g_sym] = size(big_g_matrix_sym);

fprintf('Computed new *symbolic* G matrix of size %i x %i\n', ...
    rows_big_g_sym, cols_big_g_sym);

[big_beta_vector_from_matricies_sym, ...
 big_beta_a0_vector_from_matricies_sym] = ...
    ConstructBigBetaVectorsFromMatricies( ...
        big_alpha_matrix, big_g_matrix_sym);
    
an_vector_sym = ...
    omega/pi*(big_i_an_matrix*big_beta_vector_from_matricies_sym);
bn_vector_sym = ...
    omega/pi*(big_i_bn_matrix*big_beta_vector_from_matricies_sym);

a0_matrix_method_sym = ...
    2*gamma10_layer1 ...
  + (omega/pi)*big_i_a0_vector'*big_beta_a0_vector_from_matricies_sym;

a_matrix_method_sym = [a0_matrix_method_sym; an_vector_sym]';
b_matrix_method_sym = [0; bn_vector_sym]';

n_matrix_method = 0:number_fourier_coefs_n;

% Check the symbolic computations by substituting in the known values
a_matrix_method_sym_eval = ...
    subs(a_matrix_method_sym, gamma10_layer0_sym, gamma10_layer0);
a_matrix_method_sym_eval = ...
    subs(a_matrix_method_sym_eval, gamma11_layer0_sym, gamma11_layer0);
a_matrix_method_sym_eval = ...
    subs(a_matrix_method_sym_eval, gamma11_layer1_sym, gamma11_layer1);

b_matrix_method_sym_eval = ...
    subs(b_matrix_method_sym, gamma10_layer0_sym, gamma10_layer0);
b_matrix_method_sym_eval = ...
    subs(b_matrix_method_sym_eval, gamma11_layer0_sym, gamma11_layer0);
b_matrix_method_sym_eval = ...
    subs(b_matrix_method_sym_eval, gamma11_layer1_sym, gamma11_layer1);

a_matrix_method_sym_eval = double(a_matrix_method_sym_eval);
b_matrix_method_sym_eval = double(b_matrix_method_sym_eval);

figure('Renderer', 'painters', 'Position', [100 100 1100 500]);
subplot(211);
hb1 = bar( ...
    n_measured, [a_measured' a_matrix_method_sym_eval']);
xlabel('$$n$$');
ylabel('$$a$$');
grid on;
grid minor;
xticks(min(n_measured):max(n_measured));
title('Fourier Harmonics');
set(hb1(1), 'FaceColor', 'b');
set(hb1(2), 'FaceColor', 'g');
legend('Numerical', 'Matrix');

subplot(212);
hb2 = bar( ...
    n_measured, [b_measured' b_matrix_method_sym_eval']);
xlabel('$$n$$');
ylabel('$$b$$');
grid on;
grid minor;
xticks(min(n_measured):max(n_measured));
set(hb2(1), 'FaceColor','b');
set(hb2(2), 'FaceColor','g');

fprintf('Built symbolic polynomial system.\n');


%% Try to Solve the Symbolic System with Groebner Basis

fprintf('\nAttempting to solve symbolic system...\n');

a_sys = a_matrix_method_sym - a_measured;
b_sys = b_matrix_method_sym - b_measured;

a_cell_strs = SymbolicArrayToCellStrings(a_sys);
b_cell_strs = SymbolicArrayToCellStrings(b_sys);

%groebner(a_cell_strs, 'lex', {'x','y','z'})

% TODO: How long does this take??
fprintf('Attempting to compute groebner basis...\n');
%g_a_sys = gbasis(a_sys(1:3));
%g_b_sys = gbasis(b_sys(1:3));

fprintf('Direct computation of Groebner basis takes too long...\n');

