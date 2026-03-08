function GenerateGammaListPlots( ...
    gamma_lists_inputs, gamma_lists_outputs)

design_flags = GetDesignFlags();

min_y = -1.5;
max_y = 1.5;

x_bounds = [min(design_flags.psi) max(design_flags.psi)];
y_bounds = [min_y max_y];

% Plot truth
fh = figure;
plot( ...
    design_flags.psi, gamma_lists_outputs.y_truth, 'linewidth', 2);
grid on;
xlabel('\psi');
ylabel('y(\psi)');
title('True Neuron Output');
xlim(x_bounds);
ylim(y_bounds);
legend(GetLegendStrings(gamma_lists_inputs.y_truth));
saveas(fh, './Plots/TrueNeuronOutput.png');

% Plot taylor fourier
fh = figure;
plot( ...
    design_flags.psi, gamma_lists_outputs.y_taylor_fourier, ...
    'linewidth', 2);
grid on;
xlabel('\psi');
ylabel('y(\psi)');
title('Neuron Output via Taylor Series Expansion');
xlim(x_bounds);
ylim(y_bounds);
legend(GetLegendStrings(gamma_lists_inputs.y_taylor_fourier));
saveas(fh, './Plots/TaylorNeuronOutput.png');

% Plot exponential fourier
fh = figure;
plot( ...
    design_flags.psi, gamma_lists_outputs.y_exponential_fourier, ...
    'linewidth', 2);
grid on;
xlabel('\psi');
ylabel('y(\psi)');
title('Neuron Output via Sum of Exponentials Expansion');
xlim(x_bounds);
ylim(y_bounds);
legend(GetLegendStrings(gamma_lists_inputs.y_exponential_fourier));
saveas(fh, './Plots/SumOfExponentialsNeuronOutput.png');

% Plot modified fourier
fh = figure;
plot( ...
    design_flags.psi, gamma_lists_outputs.y_modified_fourier, ...
    'linewidth', 2);
grid on;
xlabel('\psi');
ylabel('y(\psi)');
title('Neuron Output via Modified Expansion');
xlim(x_bounds);
ylim(y_bounds);
legend(GetLegendStrings(gamma_lists_inputs.y_modified_fourier));
saveas(fh, './Plots/ModifiedNeuronOutput.png');

end

