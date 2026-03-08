function defective_mlp_params = IntroduceMinorMLPDefect(mlp_params)

defective_mlp_params = mlp_params;

bias_defect_flag = ...
    rand(1) < numel(mlp_params.w_layer0)/numel(mlp_params.b_layer0);

if bias_defect_flag
    defect_idx = randi(numel(mlp_params.b_layer0));
    defect = 2*(rand(1) - 0.5);
    defective_mlp_params.b_layer0(defect_idx) = ...
        mlp_params.b_layer0(defect_idx) + defect;
else
    defect_idx = randi(numel(mlp_params.b_layer0));
    defect = 2*(rand(1) - 0.5);
    defective_mlp_params.w_layer0(defect_idx) = ...
        mlp_params.w_layer0(defect_idx) + defect;
end

end

