function PlotInputSignal(cycles, v)
figure;
plot(cycles, v, 'k', 'linewidth', 2);
title('Signal At Input to Hyperbolic Tangent');
xlabel('t (cycles)');
ylabel('v(t)');
grid on;
grid minor;
end

