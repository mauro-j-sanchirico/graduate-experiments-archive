clc; clear; close all;

t = 0:0.1:2*pi;

UkeForce = sin(t);
ToriForce = sin(t);

[WastedForce NeededForce] = szin(ToriForce, UkeForce);
