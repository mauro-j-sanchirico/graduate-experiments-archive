%% PlotTestPerformanceDriver
%% Plots Test Performance Statistics

clc; clear; close all;
RunInitializationRoutine

set(groot, 'defaultAxesFontSize', 18);


%% Load data
load('saved_tpr_roc.txt');
load('saved_measurement_snr_roc.txt');
load('saved_fpr_roc.txt');
load('saved_error_threshold_roc.txt');


%% Sorting and downselection

measurement_snrs = sort(unique(saved_measurement_snr_roc));

%colors = ['b', 'g', 'c', 'm', 'r', 'y'];
colors = ['k', 'k', 'k'];
linestyles = {':', '--', '-'};

%% Box Plot ROC (TPR wrt. FPR)

plot_snrs = [25 50 100];
color_idx = 1;

fig = figure('Renderer', 'painters', 'Position', [10 60 850 600]);

for snr_idx = 1:length(measurement_snrs)
    
    snr = measurement_snrs(snr_idx);
    
    if sum(snr == plot_snrs) < 1
        continue;
    end
    
    selection = saved_measurement_snr_roc == snr;
    fpr = saved_fpr_roc(selection);
    tpr = saved_tpr_roc(selection);
    thresh = saved_error_threshold_roc(selection);

    subplot(311);
    plot(fpr, tpr, ...
        'linestyle', linestyles{color_idx}, 'color', colors(color_idx));
    hold on;
    grid on;
    grid minor;
    title('ROC');
    xlabel('FPR');
    ylabel('TPR');
    
    subplot(312);
    semilogx(thresh, fpr, ...
        'linestyle', linestyles{color_idx}, 'color', colors(color_idx));
    hold on;
    xlim([1e-6 1e2]);
    grid on;
    grid minor;
    xlabel('Defect Tolerance $$\varepsilon$$');
    ylabel('FPR');
    
    subplot(313);
    semilogx(thresh, tpr, ...
        'linestyle', linestyles{color_idx}, 'color', colors(color_idx));
    hold on;
    xlim([1e-6 1e2]);
    grid on;
    grid minor;
    xlabel('Defect Tolerance $$\varepsilon$$');
    ylabel('TPR');
    
    color_idx = color_idx + 1;

end

legend('SNR = 25 dB', 'SNR = 50 dB', 'SNR = 100 dB', ...
    'location', 'southwest');

saveas(fig, 'Images/ROC.png');