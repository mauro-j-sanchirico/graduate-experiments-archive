clc; clear; close all;

syms x11 x12 x13
syms x21 x22 x23
syms x31 x32 x33

syms y1 y2 y3;

x = [x11 x12 x13;
     0   x22 x23;
     0   0   x33];

y = [y1 0  0;
     y1 y2 0;
     y1 y2 y3];

% Matrix notation
diag(x*y)

% More efficient way of doing the same thing in matlab
sum(x.*y.', 2)
