function VisualizeMeasuredAndReconstructedResponses( ...
    t, y_measured, y_reconstructed)

fig_handle = figure;
plot(t, y_measured, 'b', 'linewidth', 6);
hold on;
plot(t, y_reconstructed, 'g', 'linewidth', 2);
grid on; grid minor;
title('Neural Network Output');
legend('Measured', 'Reconstructed');
xlabel('$$t$$');
ylabel('$$y(t)$$');
saveas(fig_handle, './Images/NetworkMeasuredAndReconstructedResponses.png');

end
