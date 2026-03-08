function e = ComputeWeightsError(mlp_params1, mlp_params2)

m1 = ConvertMLPParamsToVector(mlp_params1);
m2 = ConvertMLPParamsToVector(mlp_params2);

e = sum((m1 - m2).^2);

end

