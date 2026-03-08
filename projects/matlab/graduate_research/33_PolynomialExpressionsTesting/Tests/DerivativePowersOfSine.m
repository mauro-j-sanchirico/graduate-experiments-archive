clc; clear; close all;

psi = 0:0.01:2*pi;

figure;
subplot(211)
for k = 1:15
    dxdpsi = k.*cos(psi).*sin(psi).^(k-1)
    plot(psi, dxdpsi, 'k', 'linewidth', 0.5);
    hold on
end
plot(pi/2, 0, 'x');
plot(2*pi/2, 0, 'x');
plot(3*pi/2, 0, 'x');
plot(4*pi/2, 0, 'x');

subplot(212)
for k = 1:15
    plot(psi, cos(psi));
    hold on;
    plot(psi, sin(psi));
end
plot(psi, zeros(size(psi)), 'k');