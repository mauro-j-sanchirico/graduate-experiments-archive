clc; clear; close all

freqs = 1:0.04:2.0;
sz = 0.*freqs;

phases = 0:0.5:pi;

sz_phase = zeros(1,length(phases)*length(freqs));

figure(1)
for j = 1:length(phases)
for i = 1:length(freqs)
RAD_TO_DEG = 180/pi;

% Uke Parameters
A_U = 10000;
f_U = 1;
phi_U = 0;

omega_U = 2*pi*f_U;
P_U = 1/f_U;

% Tori Parameters
A_T = 1;
f_T = freqs(i);
phi_T = phases(j);

omega_T = 2*pi*f_T;
P_T = 1/f_T;

% Computing the Peroiod of the sum geometrically
[N_U D_U] = rat(P_U);
[N_T D_T] = rat(P_T);

lcm(D_U, D_T);
gcd(N_U, N_T);

P = lcm(N_U, N_T)/gcd(D_U, D_T);

tmin = 0;
tmax = P;
dt = 0.01;

t = tmin:dt:tmax;

F_U = A_U.*sin(omega_U.*t - phi_U);
F_T = A_T.*sin(omega_T.*t - phi_T);

F_R = F_U + F_T;

addpath ../CEF
F_W = CEF(F_R, F_U) - F_U;
F_N = F_T - F_W;

addpath ../absImpulse
J_W = absImpulse(t, F_W);
J_N = absImpulse(t, F_N);
J_T = absImpulse(t, F_T);

sz(i) = J_W/J_T;
i
end
plot(freqs, sz);
hold on
j
end

%figure(1)
%plot(t,F_U, 'color', 'b');
%hold on
%plot(t,F_T, 'color', 'c');
%plot(t,F_R, 'color', 'g');
%plot(t,F_W, 'color', 'r', 'linewidth', 2);
%plot(t,F_N, 'color', 'm', 'linewidth', 2);

%plot(t,0.*F_U+A_U, 'color', 'k', 'LineStyle', ':');
%plot(t,0.*F_U-A_U, 'color', 'k', 'LineStyle', ':');

%figure(2)
%for j = 1:length(phases);
%plot(freqs, sz_phase(j));
%hold on
%end
%xlim([0.9 2.1]);

