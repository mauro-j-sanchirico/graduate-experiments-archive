%% EvaluateMLPCostFunction
%
% @breif Defines a loss function which can be used to adjust a MLP
% parameter vector to produce output that matches a measured output as
% closely as possible in the least squares sense.
%
% @param[in] mlp_param_vector - The parameters of the MLP as a single
% vector to be optimized (not in struct form).
%
% @param[in] x_stimuli - The stimulus to use when trying to produce the
% desired output (i.e. the sitmulus to feed into the neural network who's
% parameters are being adjusted.
%
% @param[in] y_measured - The measured output that is to be reproduced
%
% @returns cost_vector - the vector of outputs to be minimized in the
% least squares sense.
%

function cost_vector = EvalMLPCostFunction( ...
    mlp_param_vector, x_stimulus, y_measured)

mlp_params = ConvertVectorToMLPParams(mlp_param_vector);
y_response = EvalMLP(mlp_params, x_stimulus);
cost_vector = y_response(:) - y_measured(:);

end

