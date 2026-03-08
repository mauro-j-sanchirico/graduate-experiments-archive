clc; clear; close all

RAD_TO_DEG = 180/pi;

% Uke Parameters
A_U = 1;
f_U = 1;
phi_U = 0;

omega_U = 2*pi*f_U;
P_U = 1/f_U;

% Tori Parameters
A_T = 1;
f_T = 1.09;
phi_T = 0;

omega_T = 2*pi*f_T;
P_T = 1/f_T;

% Computing the Peroiod of the sum geometrically
[N_U D_U] = rat(P_U);
[N_T D_T] = rat(P_T);

lcm(D_U, D_T)
gcd(N_U, N_T)

P = lcm(N_U, N_T)/gcd(D_U, D_T)

tmin = 0;
tmax = P;
dt = 0.01;

t = tmin:dt:tmax;

F_U = A_U.*sin(omega_U.*t - phi_U);
F_T = A_T.*sin(omega_T.*t - phi_T);

F_R = F_U + F_T;

t_DEG = t.*RAD_TO_DEG;

figure(1)
plot(t,F_U, 'color', 'b');
hold on
plot(t,F_T, 'color', 'c');
plot(t,F_R, 'color', 'g');

plot(t,0.*F_U+A_U, 'color', 'k', 'LineStyle', ':');
plot(t,0.*F_U-A_U, 'color', 'k', 'LineStyle', ':');

