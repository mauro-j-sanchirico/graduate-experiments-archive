clc; clear; close all

freqs = [0.5];

phases = 0:0.1:2*pi;

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
dt = 0.001;

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
plot(phases, sz, 'color', colors(mod(i-1,4)+1));
hold on

L=length(sz);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
%SZ = fft(sz,NFFT)/L;
%f = Fs/2*linspace(0,1,NFFT/2+1);
F(:,i) = fftshift(fft(sz,NFFT));

end

figure(2)
plot(abs(F));

