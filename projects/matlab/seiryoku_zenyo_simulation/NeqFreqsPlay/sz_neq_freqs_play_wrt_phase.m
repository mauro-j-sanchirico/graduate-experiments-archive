clc; clear; close all

freqs = [3/2 5/4 7/4 9/8 11/8];

phases = 0:0.05:2*pi;

sz = phases.*0;

for i = 1:length(freqs);
for j = 1:length(phases)
RAD_TO_DEG = 180/pi;

% Uke Parameters
A_U = 1;
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
N = 5000;
dt = (tmax-tmin)/(N-1);

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

sz(j) = J_N/J_W;
j
end

colors = ['b', 'g', 'c', 'm'];

figure(1)
plot(phases/pi, sz, 'color', colors(mod(i-1,4)+1));
hold on

%ASDF(i) = absImpulse(phases, sz);
%ASDF(i) = mean(sz); %max(sz) - min(sz)
ASDF(i) = peak2peak(sz);
end

%figure(2)
%plot(freqs, ASDF);

[X I] = sort(ASDF, 'descend');

[N, D] = rat(freqs(I));

fprintf('Ratios in order:\n');

for i=1:length(N)
   fprintf('%i/%i..........%f\n', N(i), D(i),X(i));
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

