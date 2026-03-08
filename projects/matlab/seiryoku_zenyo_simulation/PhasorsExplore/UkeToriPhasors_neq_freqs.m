%% Exploration of a math trick for phasors of unequal frequency
%
% @file UkeToriPhasors_neq_freqs.m
%
% @brief This file explores the idea of analysing phasors of
%        unequal frequency by writing the phase shift of one phasor
%        as a function of time.
%

%% Set Up

RAD_TO_DEG = 180/pi;

tmin = 0;
tmax = 2;
dt = 0.01;

t = tmin:dt:tmax;

A_U = 1;
phi_U = 0;
f_U = 1;
w_U = 2*pi*f_U;

A_T = 1;
phi_T = 0;
f_T = 2;
w_T = 2*pi*f_T;

phi_t = (w_U - w_T).*t - phi_T;

A_RX = A_U*cos(phi_U) + A_T.*cos(phi_t);
A_RY = A_U*sin(phi_U) + A_T.*cos(phi_t);

A_R = sqrt(A_RX.^2 + A_RY.^2);

phi_R = atan(A_RY./A_RX);

F_R = A_R.*sin(w_U.*t - phi_R);

figure(1)
subplot(4,1,1);
plot(t, phi_t);

subplot(4,1,2);
plot(t, A_R);

subplot(4,1,3);
plot(t, phi_R);

subplot(4,1,4);
plot(t, F_R);



