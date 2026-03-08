clc; clear; close all;

RAD_TO_DEG = 180/pi;

t_min = 0;
t_max = 2*pi;
d_t   = 0.01;

t = t_min:d_t:t_max;

phi_min = 0;
phi_max = 4*pi;
d_phi   = 0.005;

phi = phi_min:d_phi:phi_max;
L_phi = length(phi);

J_Tori   = zeros(1,L_phi);
J_Wasted = zeros(1,L_phi);
J_Needed = zeros(1,L_phi);

A_Uke = 8;
A_Tori = 1;

for i = 1:L_phi
    F_Uke = A_Uke.*sin(t);
    F_Tori = A_Tori.*sin(t - phi(i));
    
    [J_Tori(i) J_Wasted(i) J_Needed(i)] = ...
                          analyzeImpulse(t, F_Uke, F_Tori);
end

figure(1)
hold on
plot(phi.*RAD_TO_DEG, J_Tori,   'color', 'b', 'LineWidth', 2);
plot(phi.*RAD_TO_DEG, J_Wasted, 'color', 'r', 'LineWidth', 3);
plot(phi.*RAD_TO_DEG, J_Needed, 'color', 'm', 'LineWidth', 3);
xlabel('Phi (Deg)');
legend('Total Impulse (Ns)', ...
       'Wasted Impulse (Ns)', ...
       'Needed Impulse (Ns)');
axis([phi_min*RAD_TO_DEG ...
      phi_max*RAD_TO_DEG ...
      1.1*min([J_Tori J_Wasted J_Needed]) ...
      1.1*max([J_Tori J_Wasted J_Needed])]);
  