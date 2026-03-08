function PlotInputSignalWithRoots(cycles, v, theta)

figure;
plot(cycles, v, 'k', 'linewidth', 2);
hold on;
plot(theta(1), 0, 'ko', 'MarkerSize', 10, 'linewidth', 2);
plot(theta(2), 0, 'k+', 'MarkerSize', 10, 'linewidth', 2);
xlabel('t (cycles)');
ylabel('v(t)');
title('Roots of v(t)');
grid on
grid minor
legend('y(t)', '\theta_1', '\theta_2');

end

