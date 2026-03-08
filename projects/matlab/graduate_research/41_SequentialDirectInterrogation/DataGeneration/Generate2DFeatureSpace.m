function [x_inputs, x_neq1_zero, x_neq2_zero, x_inputs_sweep] = ...
    Generate2DFeatureSpace()

analysis_params = GetAnalysisParams();

max_feature_value = analysis_params.max_feature_value;
n_feature_points = analysis_params.n_feature_points;

x1_gridv = ...
    linspace(-max_feature_value, max_feature_value, n_feature_points);
x2_gridv = x1_gridv;

x_inputs = combvec(x1_gridv, x2_gridv);

x_neq1_zero = [x1_gridv; zeros(size(x1_gridv))];
x_neq2_zero = [zeros(size(x2_gridv)); x2_gridv];

x_inputs_sweep = [x1_gridv; x2_gridv];

end
