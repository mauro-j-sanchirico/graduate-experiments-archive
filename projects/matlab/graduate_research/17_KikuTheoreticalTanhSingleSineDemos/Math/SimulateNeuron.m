%% SimulateNeuron
%
% @brief Simulates a single neuron
%
% @param[in] input_signal_x - the input to the neuron
%
% @param[in] hidden_parameter - the gain going into the neuron
%
% @returns output_signal_y - the signal coming out of the neuron
%

function output_signal_y = ...
    SimulateNeuron(input_signal_x, hidden_parameter_w)

output_signal_y = tanh(hidden_parameter_w*input_signal_x);

end

