%% GetRandomMLPParams
%
% @breif Gets random multilayer perceptron parameters for algorithm test
%
% @returns mlp_params.w_layer0 
%     - layer 0 weight matrix (num hidden x num input)
% @returns mlp_params.w_layer1
%     - layer 1 weight matrix (num output x num hidden)
% @returns mlp_params.b_layer0
%     - layer 0 bias vector (num hidden x 1)
% @returns mlp_params.b_layer1
%     - layer 1 bias vector (num output x 1)

function mlp_params = GetRandomMLPParams()

analysis_params = GetAnalysisParams();
mlp_hyperparams = GetMLPHyperparams();

num_input = mlp_hyperparams.num_input;
num_hidden = mlp_hyperparams.num_hidden;
num_output = mlp_hyperparams.num_output;
max_weight = analysis_params.max_weight;

mlp_params.w_layer0 = (rand(num_hidden, num_input) - 0.5)*2*max_weight;
mlp_params.w_layer1 = (rand(num_output, num_hidden) - 0.5)*2*max_weight;
mlp_params.b_layer0 = (rand(num_hidden, 1) - 0.5)*2*max_weight;
mlp_params.b_layer1 = (rand(num_output, 1) - 0.5)*2*max_weight;

end
