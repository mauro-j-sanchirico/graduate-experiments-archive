%% Entropy analysis
%% Looks for Best Interrogation Signals

clc; clear; close all;

set(groot, 'defaulttextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 12);

%f1 = 3:25;
%f2 = ComputeDenominator(f1, 2);

f1 = [1:0.05:2];
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
    s1 = sin(2*pi*f1(idx)*t);
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
    %figure; histogram2(s1, s2, n_bins)
    
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


%% Identify the best frequency combination

[~, order] = sort(entropy_ratios,  'descend');

[f1_best, f2_best] = rat(f_ratios(order));

p1_best = 1./f1_best;
p2_best = 1./f2_best;

periods_best = double(lcm(sym(p1_best), sym(p2_best)));

figure;

for idx = 1:5
    
    t = linspace(0, periods_best(idx), 1e5);

    s1_best = sin(2*pi*f1_best(idx)*t);
    s2_best = sin(2*pi*f2_best(idx)*t);

    plot(s1_best,s2_best);
    hold on;
end

f1_best(1:10)
f2_best(1:10)
