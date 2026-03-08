clc; clear; close all

P1 = 1.3;
P2 = 1;

d_n = 0.5;
n_min = -10;
n_max = 10;

n_axis = n_min:d_n:n_max;

d_m = 0.5;
m_min = -10;
m_max = 10;

m_axis = m_min:d_m:m_max;

[n m] = meshgrid(n_axis, m_axis);

S = P1.*n - P2.*m;

figure(1)
surf(n, m, S);
hold on
surf(n, m, 0.*n);
plot(n_axis, P1/P2.*n_axis, 'LineWidth', 3);
alpha(0.4);

figure(2)
plot(n_axis, P1/P2.*n_axis, 'LineWidth', 3);
grid on

myXTicks = min(n_axis):1:max(n_axis);
set(gca, 'XTick', myXTicks);

myYTicks = min(m_axis):1:max(m_axis);
set(gca, 'YTick', myYTicks);