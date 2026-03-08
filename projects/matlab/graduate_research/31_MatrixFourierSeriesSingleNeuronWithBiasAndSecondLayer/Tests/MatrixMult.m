clc; clear; close all;

A = sym('A', [6,3])
G = sym('G', [3,6])

diag(A*G)

A = sym('A', [2,2]);
B = sym('B', [2,2]);

A*B