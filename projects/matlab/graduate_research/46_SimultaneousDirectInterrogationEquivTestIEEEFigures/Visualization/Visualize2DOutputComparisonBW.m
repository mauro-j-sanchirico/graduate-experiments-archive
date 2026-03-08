function Visualize2DOutputComparisonBW( ...
    x_inputs, y_outputs1, y_outputs2, ...
    psi1, psi2, e, save_location)

analysis_params = GetAnalysisParams();
n_feature_points = analysis_params.n_feature_points;

x1_grid = reshape(x_inputs(1,:), [n_feature_points, n_feature_points]);
x2_grid = reshape(x_inputs(2,:), [n_feature_points, n_feature_points]);
y1_grid = reshape(y_outputs1, [n_feature_points, n_feature_points]);
y2_grid = reshape(y_outputs2, [n_feature_points, n_feature_points]);
y_err = y2_grid - y1_grid;

fig_handle = figure('Renderer', 'painters', 'Position', [10 60 800 600]);

subplot(2,2,1)

contourf(x1_grid, x2_grid, y1_grid, 'ShowText', 'On');

colormap gray; clims = caxis;
cmean = mean(clims); cdist = clims(2) - clims(1); cdist = cdist*2;
clims(1) = cmean - cdist*0.5; clims(2) = cmean + cdist*0.5;
caxis(clims);

xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title('Network 1 Output');

subplot(2,2,2)

contourf(x1_grid, x2_grid, y2_grid, 'ShowText', 'On');

colormap gray; clims = caxis;
cmean = mean(clims); cdist = clims(2) - clims(1); cdist = cdist*2;
clims(1) = cmean - cdist*0.5; clims(2) = cmean + cdist*0.5;
caxis(clims);

xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title('Network 2 Output');

subplot(2,2,3)

contourf(x1_grid, x2_grid, y_err, 'ShowText', 'On');

colormap gray; clims = caxis;
cmean = mean(clims); cdist = clims(2) - clims(1); cdist = cdist*2;
clims(1) = cmean - cdist*0.5; clims(2) = cmean + cdist*0.5;
caxis(clims);

xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
title('Error');

subplot(2,2,4)
plot(psi1, 'kx', 'linewidth', 0.5);
hold on;
plot(psi2, 'ko', 'linewidth', 0.5);
grid on; grid minor;

title(sprintf('$$\\Psi$$ Comparison, E = %.1d', e));
xlabel('Multi-Index $$\kappa$$');
ylabel('$$\Psi$$');

saveas(fig_handle, save_location);

end

