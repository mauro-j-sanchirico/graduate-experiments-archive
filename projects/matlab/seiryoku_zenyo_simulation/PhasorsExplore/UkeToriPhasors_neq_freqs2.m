%% Exploration of phasors of unequal frequency
%
% @file UkeToriPhasors_neq_freqs2.m
%
% @brief This file explores finding the intersection of two sine waves
%        with a horizontal line.

clc; clear; close all;

%% Set Up

tmin = 0;
tmax = 2*pi;
dt = 0.1;

t = tmin:dt:tmax;

A_U = 2;
phi_U = 0;
w_U = 1;

A_T = 1;
phi_T = 0;
w_T = 1;

C = 0.5;

for i = 1:length(t)
    figure(i)
      
    F_U = A_U.*sin(w_U.*t + phi_U);
    F_T = A_T.*sin(w_T.*t + phi_T);
    
    F_R = F_U + F_T;
    
    % Plot the first component, F_U
    subplot(3,1,1);
    mymin = min(F_U).*1.1;
    mymax = max(F_U).*1.1;
    plot(t, F_U);
    hold on
    scatter(t(i),F_U(i));
    line([t(i) t(i)], [mymin mymax]);
    axis([tmin tmax mymin mymax]);
    
    % Plot the second component, F_T
    subplot(3,1,2);
    target_F_T = C - F_U(i);
    mymin = min(F_T).*1.1;
    mymax = max(F_T).*1.1;
    plot(t, F_T);
    line([tmin tmax], [target_F_T target_F_T]);
    axis([tmin tmax mymin mymax]);
    
    t_a(i) = real((asin(target_F_T/A_T) + phi_T)./w_T);
    t_b(i) = (2*phi_T + pi)./w_T  - t_a(i);
    
    line([t_a(i) t_a(i)], [mymin mymax]);
    line([t_b(i) t_b(i)], [mymin mymax]);
    
    line([t_a(i)+2*pi/w_T t_a(i)+2*pi/w_T], [mymin mymax]);
    line([t_b(i)+2*pi/w_T t_b(i)+2*pi/w_T], [mymin mymax]);  
    
    % Plot the sum, F_R
    subplot(3,1,3);
    plot(t, F_R);
    axis([tmin tmax min(F_R)*1.1 max(F_R)*1.1]);
    line([tmin tmax], [C C]);
    
end