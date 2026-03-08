function VisualizeTanhSumExponentialsExpansion(v, y_tanh, y_tanh_sum_exp)

error = abs(y_tanh - y_tanh_sum_exp);

figure;
plot(v, y_tanh, 'k');
hold on;
plot(v(v>0), y_tanh_sum_exp(v>0), 'k--');
plot(v(v<0), y_tanh_sum_exp(v<0), 'k--');
grid on; grid minor;
legend('True', 'Sum of Exp.', 'location', 'southeast');
xlabel('$$v$$');
title('True and Approximate $$\tanh(v)$$');
saveas(gcf, './Images/SumExpExpansionTanh.png')

figure;
semilogy(v, error, 'k');
grid on; grid minor;
xlabel('$$v$$');
title('Error $$\varepsilon = |\tanh(v) - P_M^{SE}{\tanh}(v)|$$');
saveas(gcf, './Images/SumExpExpansionErrorTanh.png')

end

