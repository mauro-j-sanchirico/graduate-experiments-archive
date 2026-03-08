%% Main Driver: Single Neuron with Bias and Second Layer

clc; clear; close all;

addpath('./Math');
addpath('./Math/TanhExpansion');

set(0,'defaulttextInterpreter','latex');


%% Algorithm hyperparameters

number_partial_sum_terms_ns = 15;
epsilon = 0.0001;
safety_factor = 1.3;
numerical_integral_flag = true;
new_alpha_coefs = true;


%% Accessible Information

% Independent variable
psi = 0:0.1:2*pi;

% Input gain
a1 = 1;

% Input signal
x_hat_normalized_input = sin(psi);


%% Hidden information

% Biases
a0 = 1;

% Input layer weights
w10_layer0 = 1;
w11_layer0 = 1.5;

% Hidden layer weights
w10_layer1 = 0;
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
y = v1_layer1;

figure;
plot(psi, y, 'linewidth', 6, 'color', 'b');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('True Neuron Output');
grid on;


%% Expressing y using equations approximately linear in a hidden factor

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

% Using Equation I
y_eq1 = ComputeYEquationI( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    x_hat_normalized_input, alpha_coefs, number_partial_sum_terms_ns);

figure;
plot(psi, y, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_eq1, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('Equation I Neuron Output');
grid on;

% Using Equation II
y_eq2 = ComputeYEquationII( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    x_hat_normalized_input, alpha_coefs, number_partial_sum_terms_ns);

figure;
plot(psi, y, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_eq2, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('Equation II Neuron Output');
grid on;

% Using Equation III
y_eq3 = ComputeYEquationIII( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    x_hat_normalized_input, alpha_coefs, number_partial_sum_terms_ns);

figure;
plot(psi, y, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_eq3, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('Equation III Neuron Output');
grid on;

% Using Equation IIIc
y_eq3c = ComputeYEquationIIIc( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    x_hat_normalized_input, alpha_coefs, number_partial_sum_terms_ns);

figure;
plot(psi, y, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_eq3c, 'linewidth', 2, 'color', 'g');
xlabel('$$\psi$$');
ylabel('$$y$$');
title('Equation IIIc Neuron Output');
grid on;


%% Functions for checking equations

% @breif Output as predicted by equation I
function y = ComputeYEquationI( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    x_hat_normalized_input, alpha_coefs, number_partial_sum_terms_ns)

sum = 0;

for m = 1:number_partial_sum_terms_ns
    
    alpha_coef = alpha_coefs(m);
    power_factor = ...
        (gamma11_layer0*x_hat_normalized_input + gamma10_layer0).^(2*m-1);
    term = alpha_coef*power_factor;
    
    sum = sum + term;
    
end

y = gamma11_layer1*sum + gamma10_layer1;

end

% @breif Output as predicted by equation II
function y = ComputeYEquationII( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    x_hat_normalized_input, alpha_coefs, number_partial_sum_terms_ns)

outer_sum = 0;

for m_index = 1:number_partial_sum_terms_ns

    inner_sum = 0;
    
    for k_index = 0:(2*m_index-1)
        
        alpha_coef = alpha_coefs(m_index);
        j_index = 2*m_index-1;
       
        term = ...
             alpha_coef ...
            *gamma11_layer1 ...
            *gamma11_layer0^k_index ...
            *gamma10_layer0^(j_index-k_index) ...
            *nchoosek(j_index, k_index) ...
            *x_hat_normalized_input.^(k_index);
        
        inner_sum = inner_sum + term;
        
    end
    
    outer_sum = outer_sum + inner_sum;
    
end

y = outer_sum + gamma10_layer1;

end

% @breif Output as predicted by equation III
function y = ComputeYEquationIII( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    x_hat_normalized_input, alpha_coefs, number_partial_sum_terms_ns)

outer_sum = 0;

for k_index = 0:(2*number_partial_sum_terms_ns-1)

    inner_sum = 0;
    
    m_start = floor(k_index/2) + 1;
    
    for m_index = m_start:number_partial_sum_terms_ns

        j_index = 2*m_index-1;
        
        alpha_coef = alpha_coefs(m_index);
        
        big_g_product = ...
             gamma11_layer1 ...
            *gamma11_layer0^k_index ...
            *gamma10_layer0^(j_index-k_index);
        
        beta_coef = alpha_coef*big_g_product*nchoosek(j_index, k_index);

        term = beta_coef*x_hat_normalized_input.^(k_index);
        
        inner_sum = inner_sum + term;
        
    end
    
    outer_sum = outer_sum + inner_sum;
    
end

y = outer_sum + gamma10_layer1;

end


function y = ComputeYEquationIIIc( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    x_hat_normalized_input, alpha_coefs, number_partial_sum_terms_ns)

sum = 0;

k_start = 0;
k_end = 2*number_partial_sum_terms_ns - 1;

for k_index = k_start:k_end
    
    big_beta = ComputeBigBeta( ...
        number_partial_sum_terms_ns, k_index, ...
        gamma10_layer0, gamma11_layer0, gamma11_layer1, alpha_coefs);
    
    term = big_beta*x_hat_normalized_input.^k_index;
    sum = sum + term;
    
end

y = gamma10_layer1 + sum;

end

function big_beta = ComputeBigBeta( ...
    number_partial_sum_terms, k_index, ...
    gamma10_layer0, gamma11_layer0, gamma11_layer1, alpha_coefs)

sum = 0;

m_start = floor(k_index/2) + 1;
m_end = number_partial_sum_terms;

for m = m_start:m_end
    
    j = 2*m-1;
    
    little_beta = ComputeLittleBeta( ...
        j, k_index, gamma10_layer0, gamma11_layer0, ...
        gamma11_layer1, alpha_coefs);
    
    sum = sum + little_beta;
    
end

big_beta = sum;

end

function little_beta = ComputeLittleBeta( ...
    j_index, k_index, gamma10_layer0, gamma11_layer0, gamma11_layer1, alpha_coefs)

big_g = ComputeBigG( ...
    j_index, k_index, gamma10_layer0, gamma11_layer0, gamma11_layer1);
m_index = (j_index + 1)/2;
little_beta = alpha_coefs(m_index)*big_g*nchoosek(j_index, k_index);

end

function big_g = ComputeBigG( ...
    j_index, k_index, gamma10_layer0, gamma11_layer0, gamma11_layer1)

big_g = gamma11_layer1 ...
       *gamma11_layer0^k_index ...
       *gamma10_layer0^(j_index-k_index);

end
