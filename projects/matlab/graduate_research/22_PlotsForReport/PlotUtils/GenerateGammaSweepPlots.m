function GenerateGammaSweepPlots( ...
    gamma_sweep_input, gamma_sweep_errors)

fh = figure;
semilogy( ...
    gamma_sweep_input, gamma_sweep_errors.taylor_fourier, 'linewidth', 2);
hold on;
semilogy( ...
    gamma_sweep_input, gamma_sweep_errors.exponential_fourier, ...
    'linewidth', 2);
semilogy( ...
    gamma_sweep_input, gamma_sweep_errors.modified_fourier, ...
    'linewidth', 2);

grid on;
grid minor;
xlabel('\gamma');
ylabel('\epsilon(\gamma)');
title('Converge Comparison');
legend({'Taylor', 'Exponential', 'Modified'}, 'location', 'best');
saveas(fh, './Plots/Convergence.png');

fh = figure;
semilogy( ...
    gamma_sweep_input, gamma_sweep_errors.taylor_fourier, 'linewidth', 2);
hold on;
semilogy( ...
    gamma_sweep_input, gamma_sweep_errors.exponential_fourier, ...
    'linewidth', 2);
semilogy( ...
    gamma_sweep_input, gamma_sweep_errors.modified_fourier, ...
    'linewidth', 2);

grid on;
grid minor;
xlim([0 pi]);
xlabel('\gamma');
ylabel('\epsilon(\gamma)');
title('Converge Comparison');
legend({'Taylor', 'Exponential', 'Modified'}, 'location', 'best');
saveas(fh, './Plots/ConvergenceSmallNumbers.png');

end

