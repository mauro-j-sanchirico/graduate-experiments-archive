%% PlotTestPerformanceDriver
%% Plots Test Performance Statistics

clc; clear; close all;

RunInitializationRoutine


%% Load data

load('saved_accuracy_entropy.txt');
load('saved_measurement_snr_entropy.txt');
load('saved_entropy.txt');
load('saved_ratios_entropy.txt');
load('saved_amplitudes_entropy.txt');

%% Sorting and downselection

measurement_snrs = sort(unique(saved_measurement_snr_entropy));

%colors = ['b', 'g', 'c', 'm', 'r', 'y'];
colors = ['k', 'k', 'k'];
markerstyles = {'x', '+', 'o'};
linestyles = {':', '--', '-'};


%% Plot accuracy wrt. entropy

%plot_snrs = [25 50 100];
plot_snrs = 100;
%plot_ratios = [1 3 2 5/3 3/2 5/2 5/4 6/5 11/10];
plot_ratios = [3 2 3/2 5/2 5/4 6/5 11/10];
[nums, denoms] = rat(plot_ratios);
tolerance = 0.00001;
max_entropy = 500;
color_idx = 1;

fig = figure('Renderer', 'painters', 'Position', [10 60 1000 500]);

for snr_idx = 1:length(measurement_snrs)
    
    %subplot(2, 1, snr_idx);
    
    snr = measurement_snrs(snr_idx);
    
    if sum(snr == plot_snrs) < 1
        continue;
    end
    
    selection = ...
            saved_measurement_snr_entropy == snr ...
          & saved_entropy < max_entropy ...
          & ismembertol(saved_ratios_entropy, plot_ratios, tolerance) ...
          & sum(saved_amplitudes_entropy, 2) >= 2;
    
    accuracy = saved_accuracy_entropy(selection);
    entropy = round(saved_entropy(selection));
    
    [entropy, sort_order] = sort(entropy);
    accuracy = accuracy(sort_order);
%     
%     plot(entropy, accuracy, ...
%          markerstyles{color_idx}, 'color', colors(color_idx), ...
%          'linestyle', linestyles{color_idx});
    
    boxplot( ...
        accuracy, entropy, ...
        'colors', 'k', ...
        'BoxStyle', 'outline', ...
        'symbol', 'kx'); % Symbol = '' turns outliers off
    
    ho = findobj(fig,'tag','Outliers');
    set(ho,'MarkerSize',10)
    
    ax1 = gca;
    
    % Add frequency ratios to the labels
    labels = string(ax1.XAxis.TickLabels);
     
    for idx = 1:length(labels)
        labels(idx) = sprintf( ...
            '(%s, %d/%d)', labels(idx), nums(idx), denoms(idx));
    end
 
    ax1.XAxis.TickLabels = labels;

    %[x_mean, y_mean] = GetMeansFromBox(gca);
    %hold on;
    %plot(x_mean, y_mean, 'k:', 'linewidth', 1);
    %plot(x_mean, y_mean, 'k.', 'markersize', 15);
    
    ax1.FontSize = 16;
    
    color_idx = color_idx + 1;

end

%xlabel('$$\frac{\omega_1}{\omega_2}$$');
xlabel({'', 'H, $$\omega_1$$/$$\omega_2$$'});
ylabel({'Accuracy'});

grid on;
grid minor;

saveas(fig, 'Images/AccuracyWrtEntropy.png');


%% Plot accuracy wrt. ratio

color_idx = 1;
figure('Renderer', 'painters', 'Position', [10 60 700 500]);

for snr_idx = 1:length(measurement_snrs)
    
    snr = measurement_snrs(snr_idx);
    
    if sum(snr == plot_snrs) < 1
        continue;
    end
    
    selection = saved_measurement_snr_entropy == snr;
    accuracy = saved_accuracy_entropy(selection);
    ratios = saved_ratios_entropy(selection);
    
    [ratios, sort_order] = sort(ratios);
    accuracy = accuracy(sort_order);
    
    plot(ratios, accuracy, ...
         markerstyles{color_idx}, 'color', colors(color_idx));
    hold on;
    grid on;
    grid minor;
    xlabel('$$\frac{f_1}{f_2}$$');
    ylabel('Accuracy');
    
    color_idx = color_idx + 1;

end


%% Plot Entropy wrt. Ratio

color_idx = 1;
figure('Renderer', 'painters', 'Position', [10 60 700 500]);

for snr_idx = 1:length(measurement_snrs)
    
    snr = measurement_snrs(snr_idx);
    
    if sum(snr == plot_snrs) < 1
        continue;
    end
    
    selection = saved_measurement_snr_entropy == snr;
    entropy = saved_entropy(selection);
    ratios = saved_ratios_entropy(selection);
    
    [ratios, sort_order] = sort(ratios);
    entropy = entropy(sort_order);
    
    plot(ratios, entropy, ...
         markerstyles{color_idx}, 'color', colors(color_idx));
    hold on;
    grid on;
    grid minor;
    xlabel('$$\frac{f_1}{f_2}$$');
    ylabel('Entropy');
    
    color_idx = color_idx + 1;

end