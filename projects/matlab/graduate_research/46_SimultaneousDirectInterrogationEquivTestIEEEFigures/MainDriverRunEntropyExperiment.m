%% Direct Interrogation with Equivalency Check with Entropy
%% Interrogate with different signals, record accuracy vs. entropy

clc; clear; close all;
RunInitializationRoutine
exp_params = GetExperimentParams();
debug_plots = exp_params.debug_plots;

tic

%% Build an array of neural nets
%
% Here we build an array of specified networks and networks under test.
% we introduce defects into the networks under test with a probability of
% 50%.
%

% The true defect flags
defects_truth = zeros(exp_params.num_networks_under_test_entropy, 1);
defects_truth(1:2:exp_params.num_networks_under_test_entropy) = 1;

% Place holder for test error metrics
test_errors = zeros(size(defects_truth));

fprintf('Building neural nets...\n');

% Maintain a list of specified networks and networks under test
specified_networks = cell(exp_params.num_networks_under_test_entropy, 1);
networks_under_test = cell(exp_params.num_networks_under_test_entropy, 1);

for idx = 1:exp_params.num_networks_under_test_entropy
    
    defect_flag = defects_truth(idx);
    
    fprintf( ...
        '  - Generating network %i of %i. Defect = [%i]...\n', ...
        idx, exp_params.num_networks_under_test_entropy, defect_flag);
    
    mlp_params = GetRandomMLPParams();
    specified_networks{idx} = mlp_params;
    
    if defect_flag
        networks_under_test{idx} = IntroduceMajorMLPDefect(mlp_params);
    else
        networks_under_test{idx} = mlp_params;
    end
    
    % DEBUG STEP: Visualize each network
    if debug_plots
        e = VisuallyCompareTwoNeuralNetworks( ...
            specified_networks{idx}, ...
            networks_under_test{idx}, defect_flag);
    end
end
    
fprintf('Built neural nets.\n\n');


%% Interrogation and Test

% -----------------------------------------------------------------------
measurement_snr_entropy = 100;
error_threshold = 1;

f1 = [1 3 2 3/2 5/2 5/4 6/5 11/10];
f2 = ones(size(f1));

a = [1 1];
% -----------------------------------------------------------------------

% Get the fundamental period
p1 = 1./f1;
p2 = 1./f2;

periods = double(lcm(sym(p1), sym(p2)));
entropies = zeros(size(periods));

% Step 0: pre-generate tables and coefficients
fprintf('Loading tables...\n');
alpha_coefs = GetPolyCoefsTanh();
[mi_table, mc_table] = GetMultinomialTables();

for idx = 1:length(f1)  
    
    % Get a time vector spanning the fundamental period
    t = linspace(0, periods(idx), 10000);
    
    % Get two signals
    s1 = a(1)*sin(2*pi*f1(idx)*t);
    s2 = a(2)*sin(2*pi*f2(idx)*t);
    
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
    entropy = -sum(p(:).*log(p(:)));
    entropies(idx) = entropy;
    ratio = f1(idx)/f2(idx);

    % Step 1: generate the input stimuli
    fprintf('Starting interrogation with entropy %f, f1/f2 = %f...\n', entropy, ratio);
    x_stimulus = [s1; s2];

    % Step 2: collect equivalency metrics for all the networks
    for idx = 1:exp_params.num_networks_under_test_entropy

        fprintf('Starting test for network under test %i of %i.  Defect = [%i].\n', ...
            idx, exp_params.num_networks_under_test_entropy, defects_truth(idx));

        network_under_test_params = networks_under_test{idx};
        specified_network_params = specified_networks{idx};

        % Step 2a: collect noisy responses
        y_measured = CollectResponse( ...
            network_under_test_params, x_stimulus, ...
            measurement_snr_entropy);

        % Step 2b: replicate the model
        fprintf('Replicating...\n');
        replicated_network_params = SearchMLPParamsNumericalFromPoints( ...
            x_stimulus, y_measured);

        % Step 2c: check if the replicated network is equivalent to the spec
        fprintf('Checking equivalency...\n');
        [e_psi, psi_flat1, psi_flat2] = CompareMLPs( ...
            specified_network_params, replicated_network_params, ...
            alpha_coefs, mi_table, mc_table);

        test_errors(idx) = e_psi;

        fprintf('Finished test for network under test %i of %i.  Defect = [%i]. e_psi = %f\n', ...
            idx, exp_params.num_networks_under_test_entropy, defects_truth(idx), e_psi);
    
        fprintf('\n');
    
    end

    defect_detections = test_errors > error_threshold;

    positives = sum(defects_truth);
    true_positives = sum(defect_detections == 1 & defects_truth == 1);
    false_positives = sum(defect_detections == 1 & defects_truth == 0);
    num_correct = sum(defect_detections == defects_truth);
    num_samples = length(defects_truth);

    recall_entropy = true_positives / positives;
    precision_entropy = true_positives / (true_positives + false_positives);
    accuracy_entropy = num_correct / num_samples;

    fprintf('Saving recall, precision, accuracy, snr...\n');
    save('saved_recall_entropy.txt', 'recall_entropy', '-ascii', '-append');
    save('saved_precision_entropy.txt', 'precision_entropy', '-ascii', '-append');
    save('saved_accuracy_entropy.txt', 'accuracy_entropy', '-ascii', '-append');
    save('saved_entropy.txt', 'entropy', '-ascii', '-append');
    save('saved_ratios_entropy.txt', 'ratio', '-ascii', '-append');
    save('saved_amplitudes_entropy.txt', 'a', '-ascii', '-append');
    save('saved_measurement_snr_entropy.txt', 'measurement_snr_entropy', '-ascii', '-append');

end

toc