clc; clear; close all;

tmin = 0;
tmax = 2*pi;
dt = 0.001;

t = tmin:dt:tmax;

A_Uke = 2;
phi_Uke = 0;

A_Tori = 1;
phi_Tori = 0.8;

F_Uke  = A_Uke.*sin(t - phi_Uke);
F_Tori = A_Tori.*sin(t - phi_Tori);

[F_R F_Wasted F_Needed] = analyzeForce(F_Uke, F_Tori);
[J_Tori J_Wasted J_Needed] = analyzeImpulseClever(A_Uke, A_Tori, phi_Tori)
[J_Tori J_Wasted J_Needed] = analyzeImpulse(t, F_Uke, F_Tori)

addpath ./Window
[t_alpha t_beta] = getWindow(A_Uke, A_Tori, phi_Tori);
rmpath ./Window

figure(1)
hold on
plot(t,F_Uke, 'b');
plot(t,F_Tori, 'c');
xlabel('time (s)');
legend('Force Applied by Uke (N)', ...
       'Force Applied by Tori (N)');
   
ymin = 1.1*min([F_Uke F_Tori]);
ymax = 1.1*max([F_Uke F_Tori]);
axis([tmin tmax ymin ymax]);

figure(2)
hold on
plot(t,F_Uke, 'b');
plot(t,F_Tori, 'c');
plot(t,F_R, 'g');
xlabel('time (s)');
legend('Force Applied by Uke (N)', ...
       'Force Applied by Tori (N)', ...
       'Result Net Force (N)');

ymin = 1.1*min([F_Uke F_Tori F_R]);
ymax = 1.1*max([F_Uke F_Tori F_R]);
axis([tmin tmax ymin ymax]);

figure(3)
hold on
plot(t,F_Uke, 'b');
plot(t,F_Tori, 'c');
plot(t,F_R, 'g');
plot(t,F_Wasted, 'color', 'r', 'LineWidth', 3);
plot(t,F_Needed, 'color', 'm', 'LineWidth', 3);
title('Wasted Force with bounds shown');
xlabel('time (s)');
legend('Force Applied by Uke (N)',  ...
       'Force Applied by Tori (N)', ...
       'Result Net Force (N)',      ...
       'Wasted Force (N)',          ...
       'Needed Force (N)');

ymin = 1.1*min([F_Uke F_Tori F_R]);
ymax = 1.1*max([F_Uke F_Tori F_R]);
axis([tmin tmax ymin ymax]);
  
line([t_alpha t_alpha],[ymin ymax],'linestyle', ':', 'color', 'k');
line([t_beta  t_beta ],[ymin ymax],'linestyle', ':', 'color', 'k');
line([phi_Tori phi_Tori], [ymin ymax], 'color', 'k');
line([phi_Tori+pi phi_Tori+pi], [ymin ymax], 'color', 'k');

plot(t,A_Uke - F_Uke);

line([0 tmax],[A_Uke A_Uke], 'linestyle', ':', 'color', 'k');

  
