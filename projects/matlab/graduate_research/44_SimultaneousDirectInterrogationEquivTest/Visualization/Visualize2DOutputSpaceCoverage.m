function Visualize2DOutputSpaceCoverage( ...
    x_inputs, y_outputs, x_stimuli, y_measured)

analysis_params = GetAnalysisParams();
n_feature_points = analysis_params.n_feature_points;

x1_grid = reshape(x_inputs(1,:), [n_feature_points, n_feature_points]);
x2_grid = reshape(x_inputs(2,:), [n_feature_points, n_feature_points]);
y_grid = reshape(y_outputs, [n_feature_points, n_feature_points]);

fig_handle = figure;
surf(x1_grid, x2_grid, y_grid);
xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title('Network Output Surface Coverage');
grid on; grid minor;
hold on;
shading interp;
plot3(x_stimuli(1,:), x_stimuli(2,:), y_measured, 'r');
saveas(fig_handle, './Images/2DClassificationSurfaceCoverage.png');

fig_handle = figure;
contourf(x1_grid, x2_grid, y_grid, 'ShowText', 'On');
hold on;
contour(x1_grid, x2_grid, y_grid, [0 0], 'linewidth', 8, 'color', 'k');
plot(x_stimuli(1,:), x_stimuli(2,:), 'r', 'linewidth', 2);
xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title('Network Output Contour Coverage');
grid on; grid minor;
saveas(fig_handle, './Images/2DClassificationContourCoverage.png');

end

