clc; clear; close all;

w = 1;
t = -10:0.01:10;
k = 1;
g = 1;
pi2 = pi*pi;

y = 0;

for k = 1:100
    y = y + (8/pi2)*(g*sin(w.*t))./((2*k-1)^2 + (4/pi2)*(g*sin(w*t)).^2);
end

figure;
plot(t, g*sin(w*t));
hold on;
plot(t, tanh(g*sin(w*t)));
plot(t, y);
grid on
grid minor