%% Explorations into activation functions

clc; clear; close all;

%% Initial plots

t = -10:0.01:10;
f = tanh(t);
finv = atanh(t);

figure;
plot(t, f, 'linewidth', 2);
xlabel('t');
ylabel('tanh(t)');
grid on

figure;
plot(t, real(finv), 'linewidth', 2);
hold on
plot(t, imag(finv), 'linewidth', 2);
xlabel('t');
ylabel('arctanh(t)');
grid on


%% Build a single layer neural net with NL activation

% Model order
m = 5;

% Number of data points
n = 20;

% Input matrix
X = rand(m,n);

% Weight matrix
W = rand(1,m)*10;

% Evaluate the network
v = W*X;
Y = tanh(v);


%% Try to extract the weights

W_extracted = atanh(Y)/(X);

W
W_extracted
sum((W - W_extracted).^2)/length(W_extracted)

