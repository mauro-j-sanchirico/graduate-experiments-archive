function VisualizeTanhNumericalExpansion(v, y_tanh, y_tanh_numerical)

error = abs(y_tanh - y_tanh_numerical);

figure;
plot(v, y_tanh, 'k');
hold on;
plot(v, y_tanh_numerical, 'k--');
grid on; grid minor;
legend('True', 'Numerical', 'location', 'southeast');
xlabel('$$v$$');
title('True and Approximate $$\tanh(v)$$');
saveas(gcf, './Images/NumericalExpansionTanh.png');

figure;
semilogy(v, error, 'k');
grid on; grid minor;
xlabel('$$v$$');
title('Error $$\varepsilon = |\tanh(v) - P_M^{NE}{\tanh}(v)|$$');
saveas(gcf, './Images/NumericalExpansionErrorTanh.png');

end

