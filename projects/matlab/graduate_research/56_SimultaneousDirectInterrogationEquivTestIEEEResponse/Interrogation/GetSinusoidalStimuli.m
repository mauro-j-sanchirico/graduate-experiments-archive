%% GetSinusoidalStimuli
%
% @breif Returns a matrix of sinusoidal stimulus vectors
%
% @details Frequencies are determined by the settings returned by
% GetAnalysisParams.
%
% @returns t - the time vector where each element represents the time at
% which the input sample is generated.
%
% @returns x_stim - the matrix of stimulus vectors where each row
% represents the stimulus applied to one network input and each column
% represents on sample.
%

function [t, x_stim] = GetSinusoidalStimuli()

mlp_hyperparams = GetMLPHyperparams();
analysis_params = GetAnalysisParams();

[seq_length, ~] = size(analysis_params.frequency_matrix);

stim_length = analysis_params.n_interrogation_points*seq_length;
t = linspace(0, 2*pi*seq_length, stim_length);
x_stim = zeros(mlp_hyperparams.num_input, stim_length);

for seq_idx = 1:seq_length
    frequency_vector = analysis_params.frequency_matrix(seq_idx, :);
    x_seq_instance = zeros( ...
        mlp_hyperparams.num_input, ...
        analysis_params.n_interrogation_points);
    start_idx = (seq_idx - 1)*analysis_params.n_interrogation_points + 1;
    stop_idx = seq_idx*analysis_params.n_interrogation_points;
    t_seq_instance = t(start_idx:stop_idx);
    for input_idx = 1:mlp_hyperparams.num_input
        omega = frequency_vector(input_idx);
        x_seq_instance(input_idx, :) = sin(omega*t_seq_instance);
    end
    x_stim(:, start_idx:stop_idx) = x_seq_instance;
end

x_stim = analysis_params.max_feature_value*x_stim;

end

