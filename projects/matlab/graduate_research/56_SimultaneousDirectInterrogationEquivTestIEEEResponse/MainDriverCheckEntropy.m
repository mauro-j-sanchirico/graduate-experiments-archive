%% Entropy analysis
%% Looks for Best Interrogation Signals

clc; clear; close all;

set(groot, 'defaulttextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 12);

%f1 = 3:25;
%f2 = ComputeDenominator(f1, 2);

%f1 = [25/24 16/15 9/8 6/5 5/4 4/3 45/32 3/2 8/5 5/3 9/5 15/8 2 2.25 2.5 2.75 3];
f1 = [0.5 1 2 3 4];
f2 = ones(size(f1));

%[f1_grid, f2_grid] = meshgrid(f1, f2);

%f1 = f1_grid(:);
%f2 = f2_grid(:);

% Get the fundamental period
p1 = 1./f1;
p2 = 1./f2;

periods = double(lcm(sym(p1), sym(p2)));

entropies = zeros(size(periods));

for idx = 1:length(f1)  
    
    % Get a time vector spanning the fundamental period
    t = linspace(0, periods(idx), 10000);
    
    % Get two signals
    s1 = 2*sin(2*pi*f1(idx)*t);
    s2 = sin(2*pi*f2(idx)*t);
    
    % Get a histogram with an adaptive number of bins
    n_bins = round(1 + log2(length(s1)))*10;
    
    % Get the probability of each symbol
    n = histcounts2(s1, s2, n_bins);
    p = n ./ sum(n);
    p = p(:);
    
    % Remove zero probabilities
    nz = p > 0;
    p = p(nz);

    % Compute entropy
    entropies(idx) = -sum(p(:).*log(p(:)));
    
    % Plot signals
    %figure; plot(s1,s2);
    figure; histogram2(s1, s2, n_bins); view([0 90]);
    
end

f_ratios = f1./f2;

% Sorting
[f_ratios, order] = sort(f_ratios);
entropies = entropies(order);
periods = periods(order);

% Normalizing
entropies_n = entropies ./ max(entropies);
periods_n = periods ./ max(periods);

entropy_ratios = entropies_n ./ periods_n;

%% Plotting

figure;
plot(f_ratios, periods, 'kx');
xlabel('$$\frac{f_1}{f_2}$$')
ylabel('$$P = \frac{1}{\mathrm{GCD}(f_1, f_2)}$$');
title('Fundamental Periods');
grid on; grid minor;

figure;
plot(f_ratios, entropies, 'kx');
xlabel('$$\frac{f_1}{f_2}$$')
ylabel('$$E$$');
title('Entropies');
grid on; grid minor;

figure;
plot(f_ratios, entropy_ratios, 'kx');
xlabel('$$\frac{f_1}{f_2}$$')
ylabel('$$E/P$$');
title('Entropy to Period Ratio');
grid on; grid minor;

figure;
plot(periods_n, entropies_n, 'kx');
xlabel('$$Normalized P$$')
ylabel('$$Normalized E$$');
title('Entropy with Respect to Period');
grid on; grid minor;

