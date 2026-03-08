function PlotReconstructedOutputSignalWithRoots(cycles, y_approx, y, theta)

figure;
plot(cycles, y_approx, 'b-' , 'linewidth', 6);
hold on
plot(cycles, y, 'g-' , 'linewidth', 2);
plot(theta(1), 0, 'ko', 'markersize', 10, 'linewidth', 2);
plot(theta(2), 0, 'k+', 'markersize', 10, 'linewidth', 2);
xlabel('t (cycles)');
legend('Approx.', 'True', 'Known discont. 1', 'Known discont. 2');
title('Approximation vs. Truth');
grid on;
grid minor;

end

