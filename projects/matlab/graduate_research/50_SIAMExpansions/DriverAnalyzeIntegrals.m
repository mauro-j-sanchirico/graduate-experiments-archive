%% Analyzes integral formulas pertaining to a class of solitons
%% Analyzes the integrals visually and compares numerical vs. analytical

clc; clear; close all;

set(groot, 'defaulttextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 18);

addpath('Math/Integrals/CschIntegral');
addpath('Math/Integrals/SechIntegral');
addpath('Analysis');


%% Analyze cshi

j_max = 3;
r = 10;
dxi = 0.1;

PlotIntegrals( ...
    @cshi, j_max, r, dxi, ...
    '$$\mathrm{cshi}_j(\xi)$$');


%% Analyze schi

j_max = 6;
r = 10;
dxi = 0.1;

PlotIntegrals( ...
    @schi, j_max, r, dxi, ...
    '$$\mathrm{schi}_j(\xi)$$');


%% Analyze cshr

j_max = 6;
r = 10;
dxi = 0.1;

PlotIntegrals( ...
    @cshr, j_max, r, dxi, ...
    '$$\mathrm{cshr}_j(\xi)$$');


%% Analyze schr

j_max = 6;
r = 10;
dxi = 0.1;

PlotIntegrals( ...
    @schr, j_max, r, dxi, ...
    '$$\mathrm{schr}_j(\xi)$$');


%% Compare cshr analytical and numerical

j_max = 5;
r = 10;
dxi = 0.1;

CompareAnalyticalAndNumericalIntegrals( ...
    @cshr, @ComputeCshrNumerical, j_max, r, dxi, ...
    '$$\mathrm{cshr}_j(\xi)$$');


%% Compare schr analytical and numerical

j_max = 5;
r = 10;
dxi = 0.1;

CompareAnalyticalAndNumericalIntegrals( ...
    @schr, @ComputeSchrNumerical, j_max, r, dxi, ...
    '$$\mathrm{schr}_j(\xi)$$');


%% Compare cshr and schr

j_max = 3;
r = 10;
dxi = 0.1;

CompareNumericalIntegrals( ...
    @ComputeCshrNumerical,  @ComputeSchrNumerical, ...
    j_max, r, dxi, ...
    '$$\mathrm{cshr}_j(\xi)$$ and $$\mathrm{schr}_j(\xi)$$');

j_max = 6;
r = 10;
dxi = 0.1;

CompareNumericalIntegrals( ...
    @ComputeCshrNumerical,  @ComputeSchrNumerical, ...
    j_max, r, dxi, ...
    '$$\mathrm{cshr}_j(\xi)$$ and $$\mathrm{schr}_j(\xi)$$');


%% Test the hypergeometric formula for cshi

j_max = 3;
r = 10;
dxi = 0.2;

PlotIntegrals( ...
    @ComputeCshiHypergeometric, j_max, r, dxi, ...
    '$$\mathrm{cshi}_j(\xi)$$');


%% Test the hypergeometric formula for schi

j_max = 3;
r = 10;
dxi = 0.2;

PlotIntegrals( ...
    @ComputeSchiHypergeometric, j_max, r, dxi, ...
    '$$\mathrm{schi}_j(\xi)$$');
