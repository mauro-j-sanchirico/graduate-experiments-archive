%% BuildKappaTable
%% Builds a Table of Kappa Numbers
%
% @details Uses the formula in "On multisine excitation of sigmoidal
% nonlinearities" (Sanchirico) 8/11/19.
%

clc; clear; close all;
addpath('./Math');
digits(50);

p = 1:200;

Kappa = zeros(size(p));

for idx = 1:length(p)
    Kappa(idx) = ...
        ComputeMuTanhDefIntegral0InfAnalytical(vpa(p(idx))) ...
      / factorial(vpa(p(idx)));
end
