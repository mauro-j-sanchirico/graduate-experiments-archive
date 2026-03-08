%% Exploration of the nature of arcsin(sin(t))
%
% @file arcsinsinplay.m
%
% @brief In this file, the function arcsin(sin(t)) is explored
%

clc; clear; close all;

tau_min = 0;
tau_max = 2*pi;
d_tau = 0.001;

tau = tau_min:d_tau:tau_max;

A_U = 1.5;
phi_U = 0;
w_U = 1;

A_T = 1;
phi_T = 0;
w_T = 1;

t_alpha = asin(-(A_U/A_T).*sin(w_U.*tau - phi_U) + phi_T)./w_T;
t_beta = (2*phi_T + pi)./w_T  - t_alpha;

bound1 = asin(-A_T/A_U);
bound2 = asin( A_T/A_U);

figure(1)
plot3(tau, tau.*0, real(t_alpha));
hold on
plot3(tau, imag(t_alpha), tau.*0, 'color', 'r');
plot3([bound1 bound1], [0 0], [-3 3], 'color', 'k');
plot3([bound2 bound2], [0 0], [-3 3], 'color', 'k');
plot3([bound1+pi bound1+pi], [0 0], [-3 3], 'color', 'k');
plot3([bound2+pi bound2+pi], [0 0], [-3 3], 'color', 'k');
plot3([bound1+2*pi bound1+2*pi], [0 0], [-3 3], 'color', 'k');
plot3([bound2+2*pi bound2+2*pi], [0 0], [-3 3], 'color', 'k');
%plot(tau, t_beta);
%plot(tau, -pi/6.*sin(tau), 'color', 'r');
%plot(tau, F-sin(tau), 'color', 'g');