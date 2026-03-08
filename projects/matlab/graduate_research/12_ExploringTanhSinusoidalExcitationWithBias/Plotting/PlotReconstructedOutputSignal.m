function PlotReconstructedOutputSignal(cycles, y_fourier, y)

figure;
plot(cycles, y_fourier, 'b-' , 'linewidth', 6);
hold on;
plot(cycles, y, 'g-', 'linewidth', 2);
legend('Aprox.', 'True');
grid on;
grid minor;
xlabel('t (cycles)');
title('Approximation vs. Truth');

end

