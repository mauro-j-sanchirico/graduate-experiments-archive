%clc; clear; %close all;

RAD_TO_DEG = 180/pi;

A_Uke = 1;
A_Tori = 1;

phi_min = 0;
phi_max = 4*pi;
d_phi = 0.005;

phi = phi_min:d_phi:phi_max;
L = length(phi);

A_Uke = A_Uke.*ones(1, L);
A_Tori = A_Tori.*ones(1,L);

[J_Tori J_WastedC J_NeededC] = ...
   analyzeImpulseClever(A_Uke, A_Tori, phi);

figure(2)
hold on
plot(phi.*RAD_TO_DEG, J_Tori,   'color', 'b', 'LineWidth', 2);
plot(phi.*RAD_TO_DEG, real(J_WastedC), 'color', 'r', 'LineWidth', 3);
plot(phi.*RAD_TO_DEG, real(J_NeededC), 'color', 'm', 'LineWidth', 3);

plot(phi.*RAD_TO_DEG, imag(J_WastedC), 'color', 'r', ...
                                      'LineStyle', ':', ...
                                      'LineWidth', 2);
                                  
plot(phi.*RAD_TO_DEG, imag(J_NeededC), 'color', 'm', ...
                                      'LineStyle', ':', ...
                                      'LineWidth', 2);
xlabel('Phi (Deg)');
legend('Total Impulse (Ns)', ...
       'Wasted Impulse (Ns)', ...
       'Needed Impulse (Ns)', ...
       'imag[Wasted Impulse]', ...
       'imag[Needed Impulse]');

y_imag_min = min(imag([J_WastedC J_NeededC]));
y_real_min = min(real([J_Tori J_WastedC J_NeededC]));
y_axis_min = min([y_imag_min y_real_min]);

y_imag_max = max(imag([J_WastedC J_NeededC]));
y_real_max = max(real([J_Tori J_WastedC J_NeededC]));
y_axis_max = max([y_imag_max y_real_max]);
   
axis([phi_min*RAD_TO_DEG ...
      phi_max*RAD_TO_DEG ...
      1.1*y_axis_min ...
      1.1*y_axis_max]);
  
  