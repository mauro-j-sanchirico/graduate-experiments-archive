function VisualizeTanhModifiedExpansion(v, y_tanh, y_tanh_modified)

error = abs(y_tanh - y_tanh_modified);

figure;
plot(v, y_tanh, 'k');
hold on;
plot(v, y_tanh_modified, 'k--');
grid on; grid minor;
legend('True', 'Modified', 'location', 'southeast');
xlabel('$$v$$');
title('True and Approx. $$\tanh(v)$$');
saveas(gcf, './Images/ModifiedExpansionTanh.png');

figure;
semilogy(v, error, 'k');
grid on; grid minor;
xlabel('$$v$$');
title('Error $$\varepsilon = |\tanh(v) - P_M^{ME}{\tanh}(v)|$$');
saveas(gcf, './Images/ModifiedExpansionErrorTanh.png');

end

