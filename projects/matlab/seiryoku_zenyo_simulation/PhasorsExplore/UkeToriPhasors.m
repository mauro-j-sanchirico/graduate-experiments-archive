% @file UkeToriPhasors.m
%
% @brief Given two amplitudes and two angles, plots Uke and Tori
%        as phasors
%

% Set up
RAD_TO_DEG = 180/pi;

A_Uke = 1;
phi_Uke = 0;

A_Tori = 1;
phi_Tori = pi/4;

addpath ..\Phasors
[A_R phi_R] = addPhasors(A_Uke, phi_Uke, A_Tori, phi_Tori);
rmpath ..\Phasors

X_Uke  = A_Uke.*cos(phi_Uke); 
X_Tori = A_Tori.*cos(phi_Tori);

Y_Uke = A_Uke.*sin(phi_Uke);
Y_Tori = A_Tori.*sin(phi_Tori);

X_R = A_R.*cos(phi_R);
Y_R = A_R.*sin(phi_R);

% Phasor Domain
figure(1)
h_R    = compass(X_R, Y_R);
hold on
h_Uke  = compass(X_Uke,Y_Uke);
h_Tori = compass(X_Tori, Y_Tori);

set(h_Uke,'LineWidth',3)
set(h_Uke,'color', 'b');

set(h_Tori,'LineWidth',3);
set(h_Tori,'color', 'c');

set(h_R,'LineWidth',3);
set(h_R,'color','g');

legend('Result Phasor','Uke Phasor', 'Tori Phasor', ...
       'location', 'southeast');
   
% Time Domain  
tmin = 0;
tmax = 2*pi + phi_Tori;
dt = 0.001;

t = tmin:dt:tmax;

F_Uke = A_Uke.*sin(t);
F_Tori =  A_Tori.*sin(t-phi_Tori);
F_R = F_Uke + F_Tori;

figure(2)
plot(t.*RAD_TO_DEG, F_Uke, 'LineWidth', 2, 'color', 'b');
hold on
plot(t.*RAD_TO_DEG, F_Tori, 'LineWidth', 2, 'color', 'c');
plot(t.*RAD_TO_DEG, F_R, 'LineWidth', 2, 'color', 'g');

legend('f Uke', 'f Tori', 'f Result', 'location', 'southeast');
xlabel('Degrees');
