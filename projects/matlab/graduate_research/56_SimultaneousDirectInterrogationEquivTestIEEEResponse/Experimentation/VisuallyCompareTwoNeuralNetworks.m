function e = VisuallyCompareTwoNeuralNetworks(mlp1, mlp2, defect_flag)

% Get parameters
analysis_params = GetAnalysisParams();
n_feature_points = analysis_params.n_feature_points;

% Get a 2D feature space
[x_inputs, ~, ~, ~] = Generate2DFeatureSpace();

% Get response of MLPs over feature space
y_outputs1 = EvalMLP(mlp1, x_inputs);
y_outputs2 = EvalMLP(mlp2, x_inputs);

e = mse(y_outputs1, y_outputs2);

x1_grid = reshape(x_inputs(1,:), [n_feature_points, n_feature_points]);
x2_grid = reshape(x_inputs(2,:), [n_feature_points, n_feature_points]);

y_grid1 = reshape(y_outputs1, [n_feature_points, n_feature_points]);
y_grid2 = reshape(y_outputs2, [n_feature_points, n_feature_points]);

figure('Renderer', 'painters', 'Position', [10 60 800 600]);

subplot(211);
contourf(x1_grid, x2_grid, y_grid2, 'ShowText', 'On');
hold on;
contour(x1_grid, x2_grid, y_grid2, [0 0], 'linewidth', 8, 'color', 'k');
xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title_str = sprintf( ...
    'Network Under Test Output Contours (defect = %i)', defect_flag);
title(title_str);
grid on; grid minor;

subplot(212);
contourf(x1_grid, x2_grid, y_grid1, 'ShowText', 'On');
hold on;
contour(x1_grid, x2_grid, y_grid1, [0 0], 'linewidth', 8, 'color', 'k');
xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title('Specified Network Output Contours');
grid on; grid minor;

end
