function VisualizeTanhTaylorExpansion(v, y_tanh, y_tanh_taylor_series)

error = abs(y_tanh - y_tanh_taylor_series);

figure;
plot(v, y_tanh, 'k');
hold on;
plot(v, y_tanh_taylor_series, 'k--');
grid on; grid minor;
legend('True', 'Taylor', 'location', 'southeast');
xlabel('$$v$$');
title('True and Approx. $$\tanh(v)$$');
saveas(gcf, './Images/TaylorExpansionTanh.png')

figure;
semilogy(v, error, 'k');
grid on; grid minor;
xlabel('$$v$$');
title('Error $$\varepsilon = |\tanh(v) - P_M^{TE}{\tanh}(v)|$$');
saveas(gcf, './Images/TaylorExpansionErrorTanh.png')

end

