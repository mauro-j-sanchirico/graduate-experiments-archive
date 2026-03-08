function Visualize2DOutputSpaceCoverageBW( ...
    x_inputs, y_outputs, x_stimuli, t, y_measured, ...
    save_str1, save_str2, ...
    fundamental_period)

analysis_params = GetAnalysisParams();
n_feature_points = analysis_params.n_feature_points;

x1_grid = reshape(x_inputs(1,:), [n_feature_points, n_feature_points]);
x2_grid = reshape(x_inputs(2,:), [n_feature_points, n_feature_points]);
y_grid = reshape(y_outputs, [n_feature_points, n_feature_points]);

fig_handle = figure('Renderer', 'painters', 'Position', [10 60 800 600]);

contourf(x1_grid, x2_grid, y_grid, 'ShowText', 'On');

colormap gray; clims = caxis;
cmean = mean(clims); cdist = clims(2) - clims(1); cdist = cdist*2;
clims(1) = cmean - cdist*0.5; clims(2) = cmean + cdist*0.5;
caxis(clims);

hold on;
%contour(x1_grid, x2_grid, y_grid, [0 0], 'linewidth', 8, 'color', 'k');
plot(x_stimuli(1,:), x_stimuli(2,:), 'k', 'linewidth', 2);

xlabel('$$x_1$$');
ylabel('$$x_2$$');
zlabel('$$y$$');
grid on; grid minor;

saveas(fig_handle, save_str1);


fig_handle = figure('Renderer', 'painters', 'Position', [10 60 800 600]);

subplot(2,1,1);

plot(t, x_stimuli(1,:), 'k-');
hold on;
plot(t, x_stimuli(2,:), 'k--');
xlim([0, fundamental_period]);
legend('$$x_1$$', '$$x_2$$', 'location', 'southwest');
xlabel('$$t$$');
ylabel('$$x$$');
title('Stimulus Signals');
grid on; grid minor;

subplot(2,1,2);

plot(t, y_measured, 'k', 'linewidth', 2);
xlim([0, fundamental_period]);
xlabel('$$t$$')
ylabel('$$y$$')
title('Response Signal');
grid on; grid minor;

saveas(fig_handle, save_str2);

end

