function mlp_params = ConvertVectorToMLPParams(param_vector)

mlp_hyperparams = GetMLPHyperparams();

% Define start and end extraction points
w0_start = 1;
w0_end   = mlp_hyperparams.num_hidden*mlp_hyperparams.num_input;
w1_start = w0_end + 1;
w1_end   = w1_start + mlp_hyperparams.num_hidden - 1;
b0_start = w1_end + 1;
b0_end   = b0_start + mlp_hyperparams.num_hidden - 1;
b1_start = b0_end + 1;
b1_end   = b1_start + mlp_hyperparams.num_output - 1;

% Define shapes for the MLP params
w0_shape = [mlp_hyperparams.num_hidden mlp_hyperparams.num_input];
w1_shape = [mlp_hyperparams.num_output mlp_hyperparams.num_hidden];
b0_shape = [mlp_hyperparams.num_hidden 1];
b1_shape = [mlp_hyperparams.num_output 1];

% Set the MLP params
mlp_params.w_layer0 = reshape( ...
    param_vector(w0_start:w0_end), w0_shape);
mlp_params.w_layer1 = reshape( ...
    param_vector(w1_start:w1_end), w1_shape);
mlp_params.b_layer0 = reshape( ...
    param_vector(b0_start:b0_end), b0_shape);
mlp_params.b_layer1 = reshape( ...
    param_vector(b1_start:b1_end), b1_shape);

end
