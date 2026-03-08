%% Main Driver: Test Matrix Fourier Series Coefficients

clc; clear; close all;

set(0, 'defaultTextInterpreter', 'latex');

rng(1);

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

% Interrogation Signals
min_amplitude_sweep = 1;
max_amplitude_sweep = 3;
num_interogation_points_multiplier = 1;

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
w10_layer0 = 0;
w11_layer0 = 1.2;

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


%% Interrogate the system through amplitude sweep

do_amplitude_sweep = true;

if do_amplitude_sweep

    fprintf('Interrogating via amplitude sweep...\n');

    % Determine an amplitude sweep
    number_interrogation_points_big_p = ...
        number_partial_sum_terms_ns*(number_partial_sum_terms_ns + 1);

    amplitude_sweep_vector_big_a = linspace( ...
        min_amplitude_sweep, ...
        max_amplitude_sweep, ...
        num_interogation_points_multiplier ...
       *number_interrogation_points_big_p);

    % Precompute the Big I Matricies
    big_i_an_matrix = ConstructBigIanMatrix( ...
        number_fourier_coefs_n, number_partial_sum_terms_ns, omega);

    big_i_bn_matrix = ConstructBigIbnMatrix( ...
        number_fourier_coefs_n, number_partial_sum_terms_ns, omega);

    big_kappa_a = ComputeBigKappaMatrix( ...
        number_partial_sum_terms_ns, number_interrogation_points_big_p,...
        big_i_an_matrix, alpha_coefs, amplitude_sweep_vector_big_a, ...
        number_fourier_coefs_n);

    big_kappa_b = ComputeBigKappaMatrix( ...
        number_partial_sum_terms_ns, number_interrogation_points_big_p,...
        big_i_bn_matrix, alpha_coefs, amplitude_sweep_vector_big_a, ...
        number_fourier_coefs_n);

    big_kappa = [big_kappa_a; big_kappa_b];

    shin_vector = ComputeShinVector( ...
        number_partial_sum_terms_ns, w10_layer0, w11_layer0, w11_layer1);

    f_vector = big_kappa*shin_vector;
    
end


%% Analyze results attempt to invert through linear algebra

do_linear_attempts = false;

if do_linear_attempts
    % Inverse is no good:
    fprintf('Inverting system...\n');
    shin_vector_via_pinv = pinv(big_kappa)*f_vector;

    % Row reduction reveals multiple solutions:
    fprintf('Augmenting system and reducing...\n');
    augmented_system = [big_kappa f_vector];
    reduced_system = rref(augmented_system);
end


%% Invert through constrained nonlinear optimization

do_fmincon_attempts = false;

if do_fmincon_attempts

    fprintf('Attempting to solve system via fmincon...\n');

    % Build m and k tables which are used to convert between shin vector
    % indicies and m, k parameters to compute shin elements
    [m_table, k_table] = BuildMKTables(number_partial_sum_terms_ns);

    % Test for zero bias:
    epsilon = 0.00001;

    y_peak_measured = max(y_neuron_output);
    y_trough_measured = min(y_neuron_output);

    fprintf('Measured y_peak = %f\n', y_peak_measured);
    fprintf('Measured y_trough = %f\n', y_trough_measured);

    if abs(abs(y_peak_measured) - abs(y_trough_measured)) < epsilon ...
            && a_numerical_method(1) < epsilon
        zero_bias = true;
        fprintf('Detected zero bias condition.\n');
    else
        zero_bias = false;
        fprintf('Detected nonzero bias condition.\n');
    end


    % Check the ideal shin inequalities (sanity check, not part of
    % algorithm)
    [c_nl_inequalities, ceq] = CheckShinEqualitiesNoBias(...
        shin_vector, number_partial_sum_terms_ns, m_table, k_table, ...
        alpha_coefs, y_peak_measured, y_trough_measured)

    if zero_bias

        fprintf('Executing zero bias interrogation...\n');

        % Function handle - for use with fmincon, must return real scalar
        optfun = ...
            @(shin_vector_arg)mse(f_vector, big_kappa*shin_vector_arg);

        % Nonlinear constraints
        nonlcon = @(shin_vector_arg)CheckShinEqualitiesNoBias(...
            shin_vector_arg, number_partial_sum_terms_ns, ...
            m_table, k_table, ...
            alpha_coefs, y_peak_measured, y_trough_measured);

        x0 = ones(number_interrogation_points_big_p, 1);

        [aeq_no_bias, beq_no_bias] = ...
            GetConstraintsNoBias(number_partial_sum_terms_ns);

        options = optimoptions( ...
            @fmincon, 'Display', 'iter', ...
            'MaxFunctionEvaluations', 25000, ...
            'Algorithm', 'interior-point');
        % sqp, active-set, interior-point

        shin_vector_fmincon_no_bias = fmincon( ...
            optfun, x0, [], [], ...
            aeq_no_bias, beq_no_bias, [], [], nonlcon, options);

        figure;

        plot(shin_vector, 'x');
        hold on;
        plot(shin_vector_fmincon_no_bias, 'o');
        title('True Shin Vector and Shin Vector from fmincon');
        legend('true', 'fmincon');

        [~, ceq_fmincon] = CheckShinEqualitiesNoBias(...
            shin_vector_fmincon_no_bias, number_partial_sum_terms_ns, ...
            m_table, k_table, ...
            alpha_coefs, y_peak_measured, y_trough_measured);

        figure;
        semilogy(abs(ceq_fmincon), 'x');
        title('Nonlinear Constraints Minimized by fmincon');

        [w10_layer1_shin_algo, w11_layer1_shin_algo] = ...
            ExtractWeightsFromShinVectorNoBias( ...
                shin_vector_fmincon_no_bias, ...
                number_partial_sum_terms_ns, ...
                m_table, k_table)

        [w10_layer1_shin_algo_true, w11_layer1_shin_algo_true] = ...
            ExtractWeightsFromShinVectorNoBias( ...
                shin_vector, number_partial_sum_terms_ns, ...
                m_table, k_table)

    end

end
