%% Traveling Shallow Water Wave Simulation
%% Simulates traveling water waves and determines their breaking points

clc; clear; close all;


%% Simulation Parameters

% Wave params
k_wave_number = 1;
v_velocity = 3;
b = 1/15;
x0 = 70;

% Sea params
m_ocean_floor_slope = 0.05;

% Time
dt = 1;
t = 0:dt:30;

% Distance from beach
dx = 0.1;
x = 0:dx:70;


%% Simulate a flat ocean

f_ocean_floor = -m_ocean_floor_slope*x;

figure;
plot(x, f_ocean_floor, '--k', 'linewidth', 2);
xlabel('x (Distance from Shore - m)');
ylim([-5 5]);
legend('Ocean Floor');


%% Determine maximum wave height as function of distance from the beach

d_depth = -f_ocean_floor;
big_h_max = ComputeHMaxProfile(k_wave_number, d_depth);

figure;
plot(x, f_ocean_floor, '--k', 'linewidth', 2);
hold on;
plot(x, big_h_max, '-.k', 'linewidth', 2);
xlabel('x (Distance from Shore - m)');
ylim([-5 5]);
legend('Ocean Floor', 'Max. Wave Height');


%% Simulate a traveling shallow water wave

u_wave = zeros(length(t), length(x));

for idx = 1:length(t)
    t_now = t(idx);
    u_wave(idx, :) = ComputeSolitonProfile( ...
        k_wave_number, v_velocity, b, x0, x, t_now);
end

figure;
plot(x, f_ocean_floor, '--k', 'linewidth', 2)
hold on;
plot(x, big_h_max, '-.k', 'linewidth', 2);
plot(x, u_wave', '-k', 'linewidth', 1);

xlabel('x (Distance from Shore - m)');
ylim([-5 5]);
legend('Ocean Floor', 'Waves');
grid on;

%% 