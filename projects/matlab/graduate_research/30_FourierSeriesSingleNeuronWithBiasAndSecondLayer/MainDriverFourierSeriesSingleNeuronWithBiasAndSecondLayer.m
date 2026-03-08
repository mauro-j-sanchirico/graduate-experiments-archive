%% Main Driver: Fourier Series of Single Neuron with Bias and Second Layer

clc; clear; close all;

addpath('./Math');
addpath('./Math/TanhExpansion');
addpath('./Math/FourierSeries');
addpath('./Math/FourierSeriesTanhAnalytic/');


%% Algorithm hyperparameters

number_partial_sum_terms_ns = 15;
epsilon = 0.0001;
safety_factor = 1.3;
numerical_integral_flag = true;
new_alpha_coefs = true;


%% Accessible Information

% Independent variable
omega = 1;
dt = 0.0001;
t = 0:dt:2*pi/omega;
psi = omega*t;

% Input gain
a1 = 1;

% Input signal
x_hat_normalized_input = sin(psi);


%% Hidden information

% Biases
a0 = 1;

% Input layer weights
w10_layer0 =0.5;
w11_layer0 = 2;

% Hidden layer weights
w10_layer1 = 0.2;
w11_layer1 = 1;

% System input layer gains
gamma10_layer0 = w10_layer0*a0;
gamma11_layer0 = w11_layer0*a1;

% System hidden layer gains
gamma10_layer1 = w10_layer1*a0;
gamma11_layer1 = w11_layer1;

% Activation input first layer
v1_layer0 = gamma10_layer0 + gamma11_layer0*x_hat_normalized_input;

% First layer activation
x_layer1 = tanh(v1_layer0);

% Activation input second layer
v1_layer1 = gamma10_layer1 + gamma11_layer1*x_layer1;

% Second layer activation
y_neuron_output = v1_layer1;

figure;
plot(psi, y_neuron_output, 'linewidth', 6, 'color', 'b');
xlabel('\psi');
ylabel('y');
title('True Neuron Output');
grid on;
grid minor;


%% Get the alpha coefficients for analysis

if new_alpha_coefs
    
    % We always use a safety factor when computing max_v to avoid
    % underestimating it
    max_v = safety_factor*max(v1_layer0);

    alpha_coefs = ComputeAlphaExpansionCoefs( ...
        number_partial_sum_terms_ns, epsilon, ...
        max_v, numerical_integral_flag);
    
    save('alpha_coefs.mat');

else
    
    load('alpha_coefs.mat');

end


%% Compute the Fourier Series Numerically

number_fourier_harmonics_n = 15;

[a_numerical, b_numerical, c_numerical, n_fourier] = ...
    ComputeNumericalFourierSeries( ...
        psi, y_neuron_output, number_fourier_harmonics_n);

y_numerical_fourier = ...
    ComputeReconstructedFunctionFromFourierSeries( ...
        a_numerical, b_numerical, n_fourier, psi);

figure;
plot(psi, y_neuron_output, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_numerical_fourier, 'linewidth', 2, 'color', 'g');
xlabel('\psi');
ylabel('y');
title('True Neuron Output and Numerical Fourier Series Output');
grid on;
grid minor;

figure;
subplot(211);
bar(n_fourier, a_numerical, 'k');
xticks(min(n_fourier):max(n_fourier));
xlabel('n');
ylabel('a');
grid on;
grid minor;
title('Fourier Harmonics')

subplot(212);
bar(n_fourier, b_numerical, 'k');
xticks(min(n_fourier):max(n_fourier));
xlabel('n');
ylabel('b');
grid on;
grid minor;


%% Compute the Fourier Series Analytically

[a_analytic, b_analytic, c_analytic, n_analytic] = ...
    ComputeAnalyticFourierSeriesTanh( ...
        gamma10_layer0, gamma11_layer0, ...
        gamma10_layer1, gamma11_layer1, ...
        x_hat_normalized_input, alpha_coefs, ...
        number_partial_sum_terms_ns, ...
        omega, number_fourier_harmonics_n);

figure;
subplot(211);
hb1 = bar(n_fourier, [a_numerical' a_analytic']);
xlabel('n');
ylabel('a');
grid on;
grid minor;
xticks(min(n_fourier):max(n_fourier));
title('Fourier Harmonics');
set(hb1(1), 'FaceColor','b');
set(hb1(2), 'FaceColor','g');
legend('Numerical', 'Analytical');

subplot(212);
hb2 = bar(n_fourier, [b_numerical' b_analytic'], 'k');
xlabel('n');
ylabel('b');
grid on;
grid minor;
xticks(min(n_fourier):max(n_fourier));
set(hb2(1), 'FaceColor','b');
set(hb2(2), 'FaceColor','g');

