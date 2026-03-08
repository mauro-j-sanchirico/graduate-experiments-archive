clc; clear; close all;

xmin = 0;
xmax = 20;
dx = 0.01;

x = xmin:dx:xmax;

P1 = 0.8;
P2 = 1.2;

l_x = (P1/P2).*x;

l_mod1_x = mod(l_x, 1);

epsilon_x = l_x - x;

epsilon_mod1_x = mod(epsilon_x, 1);

figure(1)
plot(x, l_mod1_x);
hold on
plot(x, epsilon_mod1_x, 'color', 'g');
title('l^1(x), \epsilon^1(x)');

grid on
myXTicks = xmin:1:xmax;
set(gca, 'XTick', myXTicks);
myYTicks = min(l_mod1_x):1:max(l_mod1_x);
set(gca, 'YTick', myYTicks);