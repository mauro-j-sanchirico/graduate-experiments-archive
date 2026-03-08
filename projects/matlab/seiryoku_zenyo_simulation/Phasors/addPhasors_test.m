clc; clear; close all;

phi_min = 0;
phi_max = 4*pi;
d_phi = 0.01;

phi2 = phi_min:d_phi:phi_max;

L = length(phi2);

A1 = 1.*ones(1, L);
A2 = 1.*ones(1, L);

phi1 = zeros(1,L);

[A3 phi3] = addPhasors(A1, phi1, A2, phi2);

figure(1)
hold on
plot(phi2, A3,   'color', 'b', 'LineWidth', 3);
plot(phi2, phi3, 'color', 'c', 'LineWidth', 3);

plot(phi2, abs(A1*cos(0.5*phi2))+A2)

