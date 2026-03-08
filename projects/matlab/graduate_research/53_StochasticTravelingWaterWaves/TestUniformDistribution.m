%% Tests a uniform distribution of wavenumbers
%% Analyzes the height of a wave at a given place and time wrt. wavenumber

clc; clear; close all;


%% Params

% Wave params
alpha = 12;  % Outside amplitude
delta = -5;  % Where the wave starts

% Stochastic params
n_waves = 1000;
ka = 0;
kb = 2;

% Simulation Params
h = 2;
x_c = 20;
t_c = 5;

% Distance
x_start = 0;
x_stop = 50;
dx = 0.1;

x = x_start:dx:x_stop;

k_list = unifrnd(ka, kb, n_waves, 1);


%% Visualize the distribution of wavenumbers

figure;
hist(k_list, 25);


%% Calculate the weight height at the critical place and time

dk = 0.01;
k_sweep = ka:dk:kb;

sech_arg = k_list*x_c - 4*k_list.^3*t_c + delta;
u_wrt_k_stochastic = 12*k_list.^2 / alpha .* sech(sech_arg).^2;

sech_arg = k_sweep*x_c - 4*k_sweep.^3*t_c + delta;
u_wrt_k_sweep = 12*k_sweep.^2 / alpha .* sech(sech_arg).^2;

figure;
scatter(k_list, u_wrt_k_stochastic, 'xk');
hold on;
plot(k_sweep, u_wrt_k_sweep, '-k');
grid on;
xlabel('k (wavenumber)');
ylabel('u(x_c, t_c, k)');


%% Get the mean wave height

mean(u_wrt_k_sweep);


%% Visualize the distrbution of waveheights

figure;
hist(u_wrt_k_stochastic, 100);


%% Visualize the distribution of waves

plot_all_waves(k_list, x, t_c, alpha, delta);


%% Functions

function plot_all_waves(k_list, x, t_c, alpha, delta)

figure;
for idx = 1:length(k_list)
    k = k_list(idx);
    u = 12*k^2 / alpha * sech(k*x - 4*k^3*t_c + delta).^2;
    plot(x, u);
    hold on;
end

end
