clc; clear; close all;

tmin = 0;
tmax = 2*pi;
dt   = 0.001;

t = tmin:dt:tmax;

f = 2.*sin(t);
g = sin(t);

h = CEF(f,g);

figure(1)
hold on
plot(t,f, 'b');
plot(t,g, 'g');
plot(t,h, 'k');
xlabel('time (s)');
legend('f = 2*sin(t)', ...
       'g = sin(t)',   ...
       'h = CEF(f,g)');
axis([tmin tmax 1.1*min([f g]) 1.1*max([f g])]);
