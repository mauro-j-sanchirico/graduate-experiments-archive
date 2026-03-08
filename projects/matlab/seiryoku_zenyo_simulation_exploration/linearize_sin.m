clc; clear; close all;

tmin = 0;
tmax = 2*pi;
dt   = 0.001;

t = tmin:dt:tmax;
y1 = sin(t);
y2 = sin(2*t);
yr = y1+y2;

% Taylor series of sine
syms x
y1t = eval(subs(taylor(sin(x),   x, pi), t));
y2t = eval(subs(taylor(sin(2*x), x, pi), t));

figure(1)
plot(t, y1, 'color', 'b');
hold on
plot(t, y2, 'color', 'r');
plot(t, yr, 'color', 'm');
plot(t, y1t, 'color', 'g');
plot(t, y2t, 'color', 'g');
axis([0 2*pi -2 2]);

figure(2)
plot(t, abs(y1-y1t));




