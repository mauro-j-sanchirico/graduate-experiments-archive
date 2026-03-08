% @file getWindowTest.m
%
% @brief Tests getWindow.m and produces some plots
%
% @details Analyzes t_\alpha and t_\beta with respect to \phi
%          In between t_\alpha and t_\beta, there is a
%          "moment of opportunity" where Seiryoku Zenyo is possible.
%          The size of the "moment of opportunity" is the
%          difference between t_\alpha and t_\beta.
%
%          When t_\alpha and t_\beta are analyzed as functions of
%          phase shift, \phi, there will be some values of \phi
%          where t_alpha and t_beta are both real, and some values
%          of \phi where t_alpha and t_\beta are both imaginary, and
%          some values of \phi where t_alpha and t_beta are equal
%

clc; clear; close all;

RAD_TO_DEG = 180/pi;

A_Uke = 1;
A_Tori = 1;

phi_min = 0;
phi_max = 8*pi;
d_phi = 0.01;

phi = phi_min:d_phi:phi_max;
L = length(phi);

A_Uke = A_Uke.*ones(1, L);
A_Tori = A_Tori.*ones(1,L);

[t_alpha t_beta] = getWindow(A_Uke, A_Tori, phi);

figure(1)
hold on
plot(phi.*RAD_TO_DEG, real(t_alpha), 'color', 'm');
plot(phi.*RAD_TO_DEG, real(t_beta), 'color', 'b');

legend('t_\alpha(\phi)', ...
       't_\beta(\phi)');

figure(2)
hold on
plot(phi.*RAD_TO_DEG, real(t_alpha), 'color', 'm');
plot(phi.*RAD_TO_DEG, real(t_beta), 'color', 'b');
plot(phi.*RAD_TO_DEG, real(t_beta) - real(t_alpha), ...
    'color', 'g', ...
    'LineWidth', 2);

legend('Re[t_\alpha(\phi)]', ...
       'Re[t_\beta(\phi)]', ...
       'Re[t_\alpha(\phi)] - Re[t_\beta(\phi)]');

figure(3)
hold on
plot(phi.*RAD_TO_DEG, real(t_alpha), 'color', 'm');
plot(phi.*RAD_TO_DEG, real(t_beta), 'color', 'b');
plot(phi.*RAD_TO_DEG, real(t_beta) - real(t_alpha), ...
    'color', 'g', ...
    'LineWidth', 2); 

plot(phi.*RAD_TO_DEG, imag(t_alpha), 'color', 'r');
plot(phi.*RAD_TO_DEG, imag(t_alpha), 'color', 'r');

legend('Re[t_\alpha(\phi)]', ...
       'Re[t_\beta(\phi)]', ...
       'Re[t_\alpha(\phi)] - Re[t_\beta(\phi)]', ...
       'Im[t_\alpha(\phi)]', ...
       'Im[t_\alpha(\phi)]', ...
       'location', ...
       'southeast');