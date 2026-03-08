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

phi_DEG = phi.*RAD_TO_DEG;

figure(1)
plot3(phi_DEG, phi_DEG.*0, real(t_alpha), ...
      'color', 'm', ...
      'LineWidth', 3);
hold on
plot3(phi_DEG, phi_DEG.*0, real(t_beta), ...
      'color', 'b', ...
      'LineWidth', 3);
plot3(phi_DEG, imag(t_alpha), phi_DEG.*0, ...
      'color', 'm',...
      'LineWidth', 2, ...
      'LineStyle', '--');
plot3(phi_DEG, imag(t_beta), phi_DEG.*0, ...
      'color', 'b', ...
      'LineWidth', 2, ...
      'LineStyle', '--');
  
plot3(phi_DEG, phi_DEG.*0, real(t_beta) - real(t_alpha), ...
      'color', 'g', ...
      'LineWidth', 3);
grid on
