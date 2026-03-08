%% Main Single Neuron Simulation
%% Simulates the Interrogation of a Single Neuron Using Prisma Theorems

clc; clear; close all;

addpath('KikuAlgorithm/');
addpath('Math/');
addpath('Math/LookupTables/');
addpath('BuildLookupTables/')


%% Setup

% Design flags
design_flags = GetDesignFlags();

% Time
time_step = 0.0001;
time = 0:time_step:2*pi;

% Hidden parameters - these will not be known to the interrogation routine
hidden_parameter_list = 0.1:0.05:7;

% Estimate hidden parameters to be populated by Kiku
estimated_hidden_parameter_list = zeros(size(hidden_parameter_list));

% Interrogation signal
interrogation_signal_x = sin(time);


%% Precompute Kappa for Desired Design Parameters

if design_flags.new_q_table
    fprintf('Building a new "Q Table"...\n');
    ChangeDirAndGenerateQTable();
end

if design_flags.new_mu_table
    fprintf('Building a new "Mu Table"...\n');
    ChangeDirAndGenerateMuTable();
end

if design_flags.new_kappa_table
    fprintf('Building a new "Kappa Table"...\n');
    ChangeDirAndGenerateKappaTable();
end


%% Run Simulation

% Loop through all the simulation trials
runs = 1:length(hidden_parameter_list);

for run_idx = runs

    % Simulate stimulation of the neuron
    output_signal_y = SimulateNeuron( ...
        interrogation_signal_x, hidden_parameter_list(run_idx));
    
    % Estimate the hidden parameter
    estimated_hidden_parameter_list(run_idx) = KikuSingleNeuron( ...
        time, output_signal_y);
    
end

estimation_errors = ...
    hidden_parameter_list - estimated_hidden_parameter_list;

estimation_percent_errors = ...
    abs(estimation_errors)./hidden_parameter_list*100;


%% Analyze the results

if design_flags.hidden_parameter_plots
    figure;
    plot(hidden_parameter_list, hidden_parameter_list, 'xk');
    hold on;
    plot(hidden_parameter_list, estimated_hidden_parameter_list, 'ok');
    grid on;
    grid minor;
    xlabel('True Hidden Parameter (unknown to algorithm)');
    legend('True Hidden Parameter', 'Estimated Hidden Parameter');
    title_str = sprintf( ...
        'Interrogation Simulation for: L = %i, M = %i, N = %i', ...
        design_flags.number_of_taylor_terms_L, ...
        design_flags.number_of_exponential_terms_M, ...
        design_flags.number_of_harmonics_N);
    save_str = sprintf( ...
        'Figures/InterrogationSimulation_L%i_M%i_N%i.png', ...
        design_flags.number_of_taylor_terms_L, ...
        design_flags.number_of_exponential_terms_M, ...
        design_flags.number_of_harmonics_N);
    title(title_str);
    saveas(gcf, save_str);
end

if design_flags.error_plots
    figure;
    plot(hidden_parameter_list, estimation_errors, 'xk');
    grid on;
    grid minor;
    xlabel('True Hidden Parameter (unknown to algorithms)');
    title('Estimation Error wrt. True Hidden Parameter');

    figure;
    plot(hidden_parameter_list, estimation_percent_errors, 'xk');
    grid on;
    grid minor;
    xlabel('True Hidden Parameter (unknown to algorithms)');
    title('Estimation Percent Error wrt. True Hidden Parameter');
end