function poly_coefs = FitNumericalInterrogationPolynomials( ...
    x_stimuli, y_responses)

mlp_hyperparams = GetMLPHyperparams();
m_expansion_params = GetModifiedExpansionParams();

num_polycoefs = 2*m_expansion_params.m_index_max - 1;
fit_order = num_polycoefs - 1;

poly_coefs = zeros(mlp_hyperparams.num_input, num_polycoefs);

ws = warning('off','all');  % Turn off warnings for polyfitting

for input_idx = 1:mlp_hyperparams.num_input
    x = x_stimuli(input_idx, :);
    y = y_responses(input_idx, :);
    poly_coefs(input_idx, :) = polyfit(x, y, fit_order);
end

warning(ws);  % Turn warnings back on

end
