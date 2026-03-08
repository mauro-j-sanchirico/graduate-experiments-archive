function VisualizeYForSingleActiveInputs( ...
    x_neq1_zero, x_neq2_zero, y_neq1_zero, y_neq2_zero)

fig_handle = figure;
plot(x_neq1_zero(1,:), y_neq1_zero, 'k');
xlabel('$$x_1$$');
ylabel('$$y | x_{n\neq1} = 0$$');
title('Network Output for $$x_{n\neq1} = 0$$');
grid on; grid minor;
saveas(fig_handle, './Images/YCurveForX1Active.png');

fig_handle = figure;
plot(x_neq2_zero(2,:), y_neq2_zero, 'k');
xlabel('$$x_2$$');
ylabel('$$y | x_{n\neq2} = 0$$');
title('Network Output for $$x_{n\neq2} = 0$$');
grid on; grid minor;
saveas(fig_handle, './Images/YCurveForX2Active.png');

end
