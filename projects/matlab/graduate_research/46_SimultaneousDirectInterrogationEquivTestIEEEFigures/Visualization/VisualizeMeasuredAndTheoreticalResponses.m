function VisualizeMeasuredAndTheoreticalResponses( ...
    t, x_stimulus, y_polytest, y_measured)

fig_handle = figure;
plot(t, x_stimulus, 'k');
grid on; grid minor;
title('Neural Network Stimulus');
xlabel('$$t$$');
ylabel('$$x(t)$$');
legend('$$x_1(t)$$', '$$x_2(t)$$');
saveas(fig_handle, './Images/NetworkInterrogationStimulus.png');

fig_handle = figure;
plot(t, y_measured, 'b', 'linewidth', 6);
hold on;
plot(t, y_polytest, 'g', 'linewidth', 2);
grid on; grid minor;
title('Neural Network Output');
legend('Measured', 'Theoretical (polynomial)');
xlabel('$$t$$');
ylabel('$$y(t)$$');
saveas(fig_handle, './Images/NetworkMeasuredAndTheoreticalResponses.png');

end
