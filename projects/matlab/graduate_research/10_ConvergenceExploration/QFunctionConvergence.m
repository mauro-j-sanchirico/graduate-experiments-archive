clc; clear; close all;

L = 1:50;
A = 10;

yf = factorial(L);
yp = A.^L;

figure;

semilogy(L, yf);
hold on;
semilogy(L, yp);