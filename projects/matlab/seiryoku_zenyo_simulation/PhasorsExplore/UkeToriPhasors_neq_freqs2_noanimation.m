%% Exploration of phasors of unequal frequency
%
% @file UkeToriPhasors_neq_freqs2.m
%
% @brief This file explores finding the intersection of two sine waves
%        with a horizontal line.

clc; clear; close all;

%% Set Up

tmin = -2*pi;
tmax = 2*pi;
dt = 0.02;

t = tmin:dt:tmax;

A_U = 2;
phi_U = 0;
w_U = 5;

A_T = 1;
phi_T = 0;
w_T = 2;

C = 2;

for i = 1:length(t)
%    figure(i)
      
    F_U = A_U.*sin(w_U.*t + phi_U);
    F_T = A_T.*sin(w_T.*t + phi_T);
    
    F_R = F_U + F_T;
    
    target_F_T = C - F_U(i);
    
    t_a(i) = real((asin(target_F_T/A_T) + phi_T)./w_T);
    t_b(i) = (2*phi_T + pi)./w_T  - t_a(i);
end

figure(1)
subplot(2,1,1);
plot(t, t_a);
hold on
plot(t, t_b);

%plot(t, t_a+pi);
%plot(t, t_b+pi);

%plot(t, t_a+4.2);
%plot(t, t_b+4.2);

plot(t, t, 'color', 'r');

axis([tmin tmax -2 7]);

subplot(2,1,2);
plot(t, F_R);
axis([tmin tmax min(F_R)*1.1 max(F_R)*1.1]);
line([tmin tmax], [C C], 'color', 'r');