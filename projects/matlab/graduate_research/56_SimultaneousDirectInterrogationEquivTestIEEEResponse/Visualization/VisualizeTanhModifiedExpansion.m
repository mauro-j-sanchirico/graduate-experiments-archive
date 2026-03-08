function VisualizeTanhModifiedExpansion(v, y_tanh, y_tanh_modified)

error = abs(y_tanh - y_tanh_modified);

figure;

subplot(2,1,1)
plot(v, y_tanh_modified, 'k-');
grid on; grid minor;
xlabel('$$v$$');
title(' $\tilde{y}(v) \simeq \sum_{m=1}^{M}\alpha_{2m-1}v^{2m-1}$');

subplot(2,1,2)
semilogy(v, error, 'k');
grid on; grid minor;
xlabel('$$v$$');
title('$| \tilde{y}(v) - \tanh(v) |$');
saveas(gcf, './Images/ModifiedExpansion.png');

end

