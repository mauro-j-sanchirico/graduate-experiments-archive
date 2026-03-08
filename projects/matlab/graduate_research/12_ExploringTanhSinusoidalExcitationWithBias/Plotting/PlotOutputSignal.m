function PlotOutputSignal(cycles, v, y)

figure;
plot(cycles, v, 'b', 'linewidth', 6);
hold on;
plot(cycles, y, 'g', 'linewidth', 2);
xlabel('t (cycles)');
legend('v(t)', 'y(t) = tanh(v(t))');
title('Signal at Output of Hyperbolic Tangent');
grid on;
grid minor;

end

