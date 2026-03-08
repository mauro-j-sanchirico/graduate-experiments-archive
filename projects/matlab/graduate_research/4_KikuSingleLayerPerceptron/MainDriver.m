%% Main Driver Program for Testing the Single Layer Kiku Algorithm
%% Setup

clc; clear; close all;

%% Get a random weights and input matrix

num_data_points = 100;
model_order = 10;

x_matrix = rand(model_order, num_data_points);
w = rand(1, model_order);

%% Process the input matrix via a SLP with nonlinear output

y = SingleLayerPerceptron(w, x_matrix);

%% Use the SLP version of kiku to derive the weights from the (X,Y) pair

w_estimated = KikuSingleLayer(x_matrix, y);
mse_w = mse(w, w_estimated);
fprintf('MSE between w and estimated w: %f\n', mse_w);

%% Verify that we can extract the weights for large and small inputs
%
% Here we wish to see if there exists an input set so large that it
% saturates the activation unit and makes the system uninvertible (i.e.
% inverting the matrix when SLP Kiku is run hits machine precision).
%

x_matrix = 0.0000000001*rand(model_order, num_data_points);
y = SingleLayerPerceptron(w, x_matrix);
w_estimated = KikuSingleLayer(x_matrix, y);
mse_w = mse(w, w_estimated);

fprintf('MSE between w and estimated w for small x: %f\n', mse_w);

x_matrix = 4*rand(model_order, num_data_points);
y = SingleLayerPerceptron(w, x_matrix);
w_estimated = KikuSingleLayer(x_matrix, y);
mse_w = mse(w, w_estimated);

fprintf('MSE between w and estimated w for large x: %f\n', mse_w);

% For large enough x, the system is uninvertible because the activation
% unit saturates and all outputs go to one.
x_matrix = 6*rand(model_order, num_data_points);
y = SingleLayerPerceptron(w, x_matrix);
w_estimated = KikuSingleLayer(x_matrix, y);
mse_w = mse(w, w_estimated);

fprintf('MSE between w and estimated w for larger x: %f\n', mse_w);
fprintf('Output matrix: y = [%f ... %f]\n', y(1), y(end));
