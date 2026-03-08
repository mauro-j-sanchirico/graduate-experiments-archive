function VisualizeMeasuredAndReconstructedResponses( ...
    t, x_stimulus, y_reconstructed, y_measured)

fig_handle = figure;
plot(t, x_stimulus, 'k');
grid on; grid minor;
title('Neural Network Stimulus');
xlabel('$$t$$');
ylabel('$$x(t)$$');
legend('$$x_1(t)$$', '$$x_2(t)$$');

fig_handle = figure;
plot(t, y_measured, 'b', 'linewidth', 6);
hold on;
plot(t, y_reconstructed, 'g', 'linewidth', 2);
grid on; grid minor;
title('Neural Network Output');
legend('Measured', 'Reconstructed');
xlabel('$$t$$');
ylabel('$$y(t)$$');

end
