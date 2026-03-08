function Visualize2DClassificationSurface(x_inputs, y_outputs)

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
title('Network Output Surface');
grid on; grid minor;
shading interp;
saveas(fig_handle, './Images/2DClassificationSurface.png');

fig_handle = figure;
contourf(x1_grid, x2_grid, y_grid, 'ShowText', 'On');
hold on;
contour(x1_grid, x2_grid, y_grid, [0 0], 'linewidth', 8, 'color', 'k');
xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title('Network Output Contours');
grid on; grid minor;
saveas(fig_handle, './Images/2DClassificationContours.png');

end

