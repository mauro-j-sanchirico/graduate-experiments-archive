function y_responses = CollectResponses(mlp_params, x_stimuli)

mlp_hyperparams = GetMLPHyperparams();
y_responses = zeros(size(x_stimuli));

for input_idx = 1:mlp_hyperparams.num_input
    
    % Turn off all inputs but the current active input
    input_mask = zeros(size(x_stimuli));
    input_mask(input_idx, :) = 1;
    x_stimulus = input_mask.*x_stimuli;
    
    % Collect the responses of each stimulus
    y_responses(input_idx, :) = EvalMLP(mlp_params, x_stimulus);
    
end

end
