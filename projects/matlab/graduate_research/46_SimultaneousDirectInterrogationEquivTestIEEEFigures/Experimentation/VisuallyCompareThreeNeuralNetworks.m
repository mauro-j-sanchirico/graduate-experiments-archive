function [e_st, e_sr, e_tr] = VisuallyCompareThreeNeuralNetworks( ...
    specified_mlp, tested_mlp, replicated_mlp, defect_flag, idx)

% Get parameters
analysis_params = GetAnalysisParams();
n_feature_points = analysis_params.n_feature_points;

% Get a 2D feature space
[x_inputs, ~, ~, ~] = Generate2DFeatureSpace();

% Get response of MLPs over feature space
y_outputs_s = EvalMLP(specified_mlp, x_inputs);
y_outputs_t = EvalMLP(tested_mlp, x_inputs);
y_outputs_r = EvalMLP(replicated_mlp, x_inputs);

e_st = mse(y_outputs_s, y_outputs_t);
e_sr = mse(y_outputs_s, y_outputs_r);
e_tr = mse(y_outputs_t, y_outputs_r);

x1_grid = reshape(x_inputs(1,:), [n_feature_points, n_feature_points]);
x2_grid = reshape(x_inputs(2,:), [n_feature_points, n_feature_points]);

y_grid_s = reshape(y_outputs_s, [n_feature_points, n_feature_points]);
y_grid_t = reshape(y_outputs_t, [n_feature_points, n_feature_points]);
y_grid_r = reshape(y_outputs_t, [n_feature_points, n_feature_points]);

figure('Renderer', 'painters', 'Position', [10 60 800 600]);

subplot(311);
contourf(x1_grid, x2_grid, y_grid_t, 'ShowText', 'On');
hold on;
contour(x1_grid, x2_grid, y_grid_t, [0 0], 'linewidth', 8, 'color', 'k');
xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title_str = sprintf( ...
    'Network Under Test %i - Output Contours (defect = %i), $e_{st} = %f$', ...
    idx, defect_flag, e_st);
title(title_str);
grid on; grid minor;

subplot(312);
contourf(x1_grid, x2_grid, y_grid_s, 'ShowText', 'On');
hold on;
contour(x1_grid, x2_grid, y_grid_s, [0 0], 'linewidth', 8, 'color', 'k');
xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title_str = sprintf('Specified Output Contours');
title(title_str);
grid on; grid minor;

subplot(313);
contourf(x1_grid, x2_grid, y_grid_r, 'ShowText', 'On');
hold on;
contour(x1_grid, x2_grid, y_grid_r, [0 0], 'linewidth', 8, 'color', 'k');
xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title_str = sprintf( ...
    'Replicated Network Output Contours, $e_{sr} = %f$, $e_{tr} = %f$', ...
    e_sr, e_tr);
title(title_str);
grid on; grid minor;

end
