function f_ni_nh = EvalFundamentalMLP( ...
    active_input_ni, hidden_neuron_nh, params, x)

w_layer0 = params.w_layer0;
w_layer1 = params.w_layer1;
b_layer0 = params.b_layer0;

output_neuron_no = 1;

v = w_layer0(hidden_neuron_nh, active_input_ni)*x(active_input_ni, :) ...
    + b_layer0(hidden_neuron_nh);

f_ni_nh = w_layer1(output_neuron_no, hidden_neuron_nh)*tanh(v);

end

