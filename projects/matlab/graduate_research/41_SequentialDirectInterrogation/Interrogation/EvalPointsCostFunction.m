function cost_vector = EvalPointsCostFunction( ...
    mlp_param_vector, nchoosek_table, alpha_coefs, ...
    x_stimuli, y_measured)

mlp_params = ConvertVectorToMLPParams(mlp_param_vector);
[num_inputs, ~] = size(x_stimuli);

y_response = zeros(size(y_measured));

for active_input_ni = 1:num_inputs
    y_response(active_input_ni, :) = EvalInterrogationPolynomial( ...
        active_input_ni, mlp_params, ...
        alpha_coefs, nchoosek_table, x_stimuli);
end

cost_vector = y_response(:) - y_measured(:);

end

