clc; clear; close all;

n_max = 21;

N = 0:0.01:n_max;

P1 = 1.1;
P2 = 0.9;

theta = atan(P1/P2);

L = N*tan(theta);

E = L - N;

figure(1)
plot(N,L, 'color', 'b');
hold on
plot(N,N, 'color', 'c');
plot(N,E, 'color', 'g');
plot(N,mod(E,1).*100, 'color', 'm');
plot(N,mod(L,1).*100, 'color', 'k');

legend('L', 'N', 'E', '(E % 1) * 10');

figure(2)
stem(N,L);
hold on
plot(N,mod(L,1), 'color', 'g');