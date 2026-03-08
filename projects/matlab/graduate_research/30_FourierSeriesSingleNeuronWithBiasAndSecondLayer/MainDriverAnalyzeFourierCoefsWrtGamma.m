%% Main Driver: Fourier Series Coefficients wrt. Gamma

clc; clear; close all;

addpath('./Math');
addpath('./Math/TanhExpansion');
addpath('./Math/FourierSeries');
addpath('./Math/FourierSeriesTanhAnalytic/');
addpath('./FourierCoefsAnalysis');

set(0,'defaulttextInterpreter','latex');

% Set to true to only compute every other fourier coefficient.  This
% setting is faster but should be turned off for scenarios where it is not
% known if every other fourier coefficient will have a 0 value.
use_every_other_fourier_coef = true;


%% Algorithm hyperparameters

number_partial_sum_terms_ns = 25;
epsilon = 0.0001;
safety_factor = 1.3;
numerical_integral_flag = true;
new_alpha_coefs = true;
max_expected_activation_input_v = 5;
omega = 1;


%% Get the alpha coefficients

if new_alpha_coefs
    
    % We always use a safety factor when computing max_v to avoid
    % underestimating it
    max_v = safety_factor*max_expected_activation_input_v;

    alpha_coefs = ComputeAlphaExpansionCoefs( ...
        number_partial_sum_terms_ns, epsilon, ...
        max_v, numerical_integral_flag);
    
    save('alpha_coefs.mat');

else
    
    load('alpha_coefs.mat');

end


%% Test the validity of the alpha coefficients
 
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


%% Create a space of gammas to assess the Fourier Coefficients over

% Gamma differential
dgamma = 0.2;

% System input layer gains
gamma10_layer0_grid_vector = -2:dgamma:2;
gamma11_layer0_grid_vector = -4:dgamma:4;

% System hidden layer gains
gamma10_layer1 = 0;
gamma11_layer1 = 1;

[gamma10_layer0_grid, gamma11_layer0_grid] = ...
    meshgrid(gamma10_layer0_grid_vector, gamma11_layer0_grid_vector);


%% Analyze a0 over the space of gammas

a0 = AnalyzeA0( ...
    gamma10_layer0_grid_vector, gamma11_layer0_grid_vector, ...
    gamma10_layer0_grid, gamma11_layer0_grid, ...
    gamma10_layer1, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns, omega);

figure;
surf(gamma10_layer0_grid, gamma11_layer0_grid, a0);
xlabel('$$\gamma_{10}^{(0)}$$');
ylabel('$$\gamma_{11}^{(0)}$$');
zlabel('$$a_0$$');
title('Fourier Series DC Offset wrt. $$\gamma$$');


%% Analyze a_n over the space of gammas

number_fourier_harmonics = 10;
a = cell(1, number_fourier_harmonics);

for n_fourier = 1:number_fourier_harmonics
    
    % All odd coefs are zero
    if mod(n_fourier, 2) == 1
        a{n_fourier} = zeros( ...
            length(gamma11_layer0_grid_vector), ...
            length(gamma10_layer0_grid_vector));
    else
        a{n_fourier} = AnalyzeAn( ...
            gamma10_layer0_grid_vector, gamma11_layer0_grid_vector, ...
            gamma10_layer0_grid, gamma11_layer0_grid, ...
            gamma11_layer1, alpha_coefs, number_partial_sum_terms_ns, ...
            n_fourier, omega);
    end
    
end

for n_fourier = 1:number_fourier_harmonics
    figure;
    surf(gamma10_layer0_grid, gamma11_layer0_grid, a{n_fourier});
    xlabel('$$\gamma_{10}^{(0)}$$');
    ylabel('$$\gamma_{11}^{(0)}$$');
    z_label_str = sprintf('$$a_{%i}$$', n_fourier);
    zlabel(z_label_str);
    title('Fourier Series Coefficients wrt. $$\gamma$$');
end


%% Analyze b_n over the space of gammas

number_fourier_harmonics = 10;
b = cell(1, number_fourier_harmonics);

for n_fourier = 1:number_fourier_harmonics
    
    % All even coefs are zero
    if mod(n_fourier, 2) == 0
        b{n_fourier} = zeros( ...
            length(gamma11_layer0_grid_vector), ...
            length(gamma10_layer0_grid_vector));
    else
        b{n_fourier} = AnalyzeBn( ...
            gamma10_layer0_grid_vector, gamma11_layer0_grid_vector, ...
            gamma10_layer0_grid, gamma11_layer0_grid, ...
            gamma11_layer1, alpha_coefs, number_partial_sum_terms_ns, ...
            n_fourier, omega);
    end
    
end

for n_fourier = 1:number_fourier_harmonics
    figure;
    surf(gamma10_layer0_grid, gamma11_layer0_grid, b{n_fourier});
    xlabel('$$\gamma_{10}^{(0)}$$');
    ylabel('$$\gamma_{11}^{(0)}$$');
    z_label_str = sprintf('$$b_{%i}$$', n_fourier);
    zlabel(z_label_str);
    title('Fourier Series Coefficients wrt. $$\gamma$$');
end
