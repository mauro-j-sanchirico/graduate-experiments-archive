%% PlotTestPerformanceDriver
%% Plots Test Performance Statistics

clc; clear; close all;
RunInitializationRoutine


%% Load data
load('saved_accuracy.txt');
load('saved_measurement_snr.txt');
load('saved_precision.txt');
load('saved_recall.txt');


%% Sorting and downselection
[~, idx] = sort(saved_measurement_snr);

saved_measurement_snr = saved_measurement_snr(idx);
saved_accuracy = saved_accuracy(idx);
saved_precision = saved_precision(idx);
saved_recall = saved_recall(idx);

max_snr = 110;
selection = saved_measurement_snr <= max_snr;
saved_measurement_snr = saved_measurement_snr(selection);
saved_accuracy = saved_accuracy(selection);
saved_precision = saved_precision(selection);
saved_recall = saved_recall(selection);


%% Box Plot Accuracy

fig = figure('Renderer', 'painters', 'Position', [10 60 1200 600]);
boxplot( ...
    saved_accuracy, saved_measurement_snr, ...
    'colors', 'k', ...
    'BoxStyle', 'outline', ...
    'symbol', 'kx'); % Symbol = '' turns outliers off 

ho = findobj(fig,'tag','Outliers');
set(ho,'MarkerSize',10)

[x_mean, y_mean] = GetMeansFromBox(gca);
hold on;
plot(x_mean, y_mean, 'k:', 'linewidth', 1);
plot(x_mean, y_mean, 'k.', 'markersize', 15);
ax = gca;
% Hide every other label
labels = string(ax.XAxis.TickLabels);
labels(2:2:end) = nan;
ax.XAxis.TickLabels = labels;
grid on;
grid minor;
xlabel('Measurement SNR (dB)');
ylabel('Accuracy');

saveas(fig, 'Images/AccuracyWrtSNR.png');


%% Box Plot Precision

figure('Renderer', 'painters', 'Position', [10 60 1000 600]);
boxplot( ...
    saved_precision, saved_measurement_snr, ...
    'colors', 'k', ...
    'BoxStyle', 'outline', ...
    'symbol', ''); % Symbol = '' turns outliers off 

[x_mean, y_mean] = GetMeansFromBox(gca);
hold on;
plot(x_mean, y_mean, 'k:', 'linewidth', 1);
plot(x_mean, y_mean, 'k.', 'markersize', 15);
grid on;
grid minor;
title('Defect Detection Precision wrt. Measurement SNR');
xlabel('Measurement SNR (dB)');


%% Box Plot Recall

figure('Renderer', 'painters', 'Position', [10 60 1000 600]);
boxplot( ...
    saved_recall, saved_measurement_snr, ...
    'color', 'k', ...
    'symbol', ''); % Symbol = '' turns outliers off

[x_mean, y_mean] = GetMeansFromBox(gca);
hold on;
plot(x_mean, y_mean, 'k:', 'linewidth', 1);
plot(x_mean, y_mean, 'k.', 'markersize', 15);
grid on;
grid minor;
title('Defect Detection Recall wrt. Measurement SNR');
xlabel('Measurement SNR (dB)');


%% Error Bar Accuracy

[xu, y_means, y_std_devs] = GetStatsFromData( ...
    saved_measurement_snr, saved_accuracy);

figure;
errorbar( ...
    xu, y_means, 2*y_std_devs, ...
    'k.', 'MarkerSize', 15);
hold on;
plot(xu, y_means, 'k:', 'linewidth', 1);
grid on;
grid minor;
title('Defect Detection Accuracy wrt. Measurement SNR');
xlabel('Measurement SNR (dB)');
yticks([0.5:0.1:1]);


%% Error Bar Precision

[xu, y_means, y_std_devs] = GetStatsFromData( ...
    saved_measurement_snr, saved_precision);

figure;
errorbar( ...
    xu, y_means, 2*y_std_devs, ...
    'k.', 'MarkerSize', 15);
hold on;
plot(xu, y_means, 'k:', 'linewidth', 1);
grid on;
grid minor;
title('Defect Detection Precision wrt. Measurement SNR');
xlabel('Measurement SNR (dB)');
yticks([0.5:0.1:1]);