%% Direct Interrogation with Equivalency Check with ROC
%% Interrogate by optimizing to meet recorded points, compute ROC

clc; clear; close all;
RunInitializationRoutine
exp_params = GetExperimentParams();
debug_plots = exp_params.debug_plots;


%% Build an array of neural nets
%
% Here we build an array of specified networks and networks under test.
% we introduce defects into the networks under test with a probability of
% 50%.
%

% The true defect flags
defects_truth = zeros(exp_params.num_networks_under_test_roc, 1);
defects_truth(1:2:exp_params.num_networks_under_test_roc) = 1;

% Place holder for test error metrics
test_errors = zeros(size(defects_truth));

fprintf('Building neural nets...\n');

% Maintain a list of specified networks and networks under test
specified_networks = cell(exp_params.num_networks_under_test_roc, 1);
networks_under_test = cell(exp_params.num_networks_under_test_roc, 1);

for idx = 1:exp_params.num_networks_under_test_roc
    
    defect_flag = defects_truth(idx);
    
    fprintf( ...
        '  - Generating network %i of %i. Defect = [%i]...\n', ...
        idx, exp_params.num_networks_under_test_roc, defect_flag);
    
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

error_threshold_sweep = logspace(-6, 2, 5000);

measurement_snr_roc = 25;

fprintf('Starting interrogation...\n');

% Step 0: pre-generate tables and coefficients
fprintf('Loading tables...\n');
alpha_coefs = GetPolyCoefsTanh();
[mi_table, mc_table] = GetMultinomialTables();

% Step 1: generate the input stimuli
fprintf('Generating stimulus...\n');
[t, x_stimulus] = GetSinusoidalStimuli();

% Step 2: collect equivalency metrics for all the networks
for idx = 1:exp_params.num_networks_under_test_roc

    fprintf('Starting test for network under test %i of %i.  Defect = [%i].\n', ...
        idx, exp_params.num_networks_under_test_roc, defects_truth(idx));

    network_under_test_params = networks_under_test{idx};
    specified_network_params = specified_networks{idx};

    % Step 2a: collect noisy responses
    y_measured = CollectResponse( ...
        network_under_test_params, x_stimulus, measurement_snr_roc);

    % Step 2b: replicate the model
    fprintf('Replicating...\n');
    %replicated_network_params = ReplicateMLPWithBackprop( ...
    %    x_stimulus, y_measured);
    replicated_network_params = SearchMLPParamsNumericalFromPoints( ...
        x_stimulus, y_measured);
    
    % DEBUG STEP: Compare the networks
    if debug_plots
        [e_st, e_sr, e_tr] = VisuallyCompareThreeNeuralNetworks( ...
            specified_networks{idx}, ...
            networks_under_test{idx}, ...
            replicated_network_params, defects_truth(idx), idx);
    end

    % Step 2c: check if the replicated network is equivalent to the spec
    fprintf('Checking equivalency...\n');
    [e_psi, psi_flat1, psi_flat2] = CompareMLPs( ...
        specified_network_params, replicated_network_params, ...
        alpha_coefs, mi_table, mc_table);

    % DEBUG STEP: Compare the Psi coefficients visually
    if debug_plots
        figure;
        plot(asinh(psi_flat1/2), 'x');
        hold on;
        plot(asinh(psi_flat2/2), 'o');
        title('Psi Coefficients Comparison')
    end

    test_errors(idx) = e_psi;

    fprintf('Finished test for network under test %i of %i.  Defect = [%i]. e_psi = %f\n', ...
        idx, exp_params.num_networks_under_test_roc, defects_truth(idx), e_psi);

    if debug_plots
        fprintf('    e_st = %f; e_sr = %f; e_tr = %f\n', ...
            e_st, e_sr, e_tr);
    end
    
    fprintf('\n');
    
end

for thresh_idx = 1:length(error_threshold_sweep)
    
    %tic
    
    error_threshold_roc = error_threshold_sweep(thresh_idx);

%     fprintf( ...
%         '2) Executing replication and equivalency test for eps = %f...\n', ...
%         error_threshold_roc);

    % Detect the defects
    defect_detections = test_errors > error_threshold_roc;

    positives = sum(defects_truth);
    true_positives = sum(defect_detections == 1 & defects_truth == 1);
    true_negatives = sum(defect_detections == 0 & defects_truth == 0);
    false_positives = sum(defect_detections == 1 & defects_truth == 0);
    false_negatives = sum(defect_detections == 0 & defects_truth == 1); 

    % True Positive Rate = True Positives / (True Positives + False Negatives)
    % False Positive Rate = False Positives / (False Positives + True Negatives)
    
    tpr_roc = true_positives / (true_positives + false_negatives);
    fpr_roc = false_positives / (false_positives + true_negatives);
    
    %fprintf('Saving recall, precision, accuracy, snr, eps...\n');
    save('saved_tpr_roc.txt', 'tpr_roc', '-ascii', '-append');
    save('saved_fpr_roc.txt', 'fpr_roc', '-ascii', '-append');
    save('saved_measurement_snr_roc.txt', 'measurement_snr_roc', '-ascii', '-append');
    save('saved_error_threshold_roc.txt', 'error_threshold_roc', '-ascii', '-append');

    if debug_plots
        figure;
        plot(test_errors, 'x');
        hold on;
        plot(defects_truth, 'o');
        legend('test errors', 'true defects');
        title('Test Errors and True Defects')

        figure;
        plot(defect_detections, 'x');
        hold on;
        plot(defects_truth, 'o');
        legend('detected defects', 'true defects');
        title('Detected Defects and True Defects');
    end

%     fprintf('TPR = %f\n', tpr_roc);
%     fprintf('FPR = %f\n', fpr_roc);

    %toc
    
end
