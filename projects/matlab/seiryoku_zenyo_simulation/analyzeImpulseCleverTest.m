clc; clear; close all;

RAD_TO_DEG = 180/pi;

A_Uke = 2;
A_Tori = 1;

phi = pi/2;

[J_Tori J_Wasted J_Needed] = ...
   analyzeImpulseClever(A_Uke, A_Tori, phi)