function param_vector = ConvertMLPParamsToVector(mlp_params)

w_layer0_flat = mlp_params.w_layer0(:);
w_layer1_flat = mlp_params.w_layer1(:);
b_layer0_flat = mlp_params.b_layer0(:);
b_layer1_flat = mlp_params.b_layer1(:);

param_vector = [
    w_layer0_flat;
    w_layer1_flat;
    b_layer0_flat;
    b_layer1_flat];

end

