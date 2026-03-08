%% Exploration of arcsine lattice case 1 (A_U > A_T)
%
% @file arcsinsinplay2.m
%
% @brief In this file, arcsine lattice case 1 is explored
%

clc; clear; close all;

tau_min = -2*pi;
tau_max = 2*pi;
d_tau = 0.001;

tau = tau_min:d_tau:tau_max;

A_U = 1;
phi_U = 0;
w_U = 1;

A_T = 1.1;
phi_T = 0;
w_T = 4;

C=0;

t_alpha = (asin( (C-A_U.*sin(w_U.*tau - phi_U))./A_T ) + phi_T)./w_T;
t_beta = (2*phi_T + pi)./w_T  - t_alpha;

t_alpha_alt = (asin(-(1/1).*sin(w_U.*tau - phi_U)) + phi_T)./w_T;

k = -2:1:2; % number of tau_1's and tau_2's to find

tau_1 = ( ((-1).^k    ).*asin(A_T/A_U)+k.*pi+phi_U)./w_U;
tau_2 = ( ((-1).^(k+1)).*asin(A_T/A_U)+k.*pi+phi_U)./w_U;

t_alpha_1 = (-pi + 2*phi_T)/(2*w_T);
t_alpha_2 = ( pi + 2*phi_T)/(2*w_T);


figure(1)
plot3(tau, tau.*0, real(t_alpha), 'color', 'r', 'linewidth', 2);
hold on
plot3(tau, tau.*0, real(t_alpha_alt), 'color', 'r', 'linewidth', 1);
for i = 1:length(k)
    plot3([tau_1(i) tau_1(i)],[0 0],[-2 2], 'color', 'b');
    plot3([tau_2(i) tau_2(i)],[0 0],[-2 2], 'color', 'c');
end
plot3([tau_min tau_max],[0 0],[0 0],'color', 'k', 'linestyle', ':');

plot3([tau_min tau_max],[0 0],[t_alpha_1 t_alpha_1],'color', 'b');
plot3([tau_min tau_max],[0 0],[t_alpha_2 t_alpha_2],'color', 'c');


delta_t = t_alpha_alt - t_alpha;

figure(2)
plot(tau,delta_t);
hold on

figure(3)
plot(tau, sin(t_alpha), 'color', 'b');
hold on
plot(tau, -A_U./A_T.*sin(w_U.*tau), 'color', 'r');