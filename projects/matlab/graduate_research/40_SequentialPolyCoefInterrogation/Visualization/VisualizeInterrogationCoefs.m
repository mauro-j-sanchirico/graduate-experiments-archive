function VisualizeInterrogationCoefs( ...
    numerical_poly_coefs, theoretical_poly_coefs, x_stimuli)

mlp_hyperparams = GetMLPHyperparams();

% Eval the numerical poly coefs and plot the result
figure;
legend_strs = cell(1, mlp_hyperparams.num_input);

for input_idx = 1:mlp_hyperparams.num_input
    x = x_stimuli(input_idx, :);
    y = polyval(numerical_poly_coefs(input_idx,:), x);
    plot(x, y);
    hold on
    legend_strs{input_idx} = ...
        sprintf('$$y|\\{x_{n\\neq%i}=0\\}$$', input_idx);
end
legend(legend_strs);
xlabel('$$x$$');
ylabel('$$y$$');
grid on; grid minor;
title('Numerical Polynomial Fit Evaluation');

% Eval the theoretical poly coefs and plot the result
figure;
legend_strs = cell(1, mlp_hyperparams.num_input);

for input_idx = 1:mlp_hyperparams.num_input
    x = x_stimuli(input_idx, :);
    y = polyval(theoretical_poly_coefs(input_idx,:), x);
    plot(x, y);
    hold on
    legend_strs{input_idx} = ...
        sprintf('$$y|\\{x_{n\\neq%i}=0\\}$$', input_idx);
end
xlabel('$$x$$');
ylabel('$$y$$');
legend(legend_strs);
grid on; grid minor;
title('Theoretical Polynomial Fit Evaluation');

% Visualize the numerical poly coefs

% flip to math ordering to visualize
numerical_poly_coefs = fliplr(numerical_poly_coefs);
theoretical_poly_coefs = fliplr(theoretical_poly_coefs);

figure;
legend_strs = cell(1, mlp_hyperparams.num_input);

for input_idx = 1:mlp_hyperparams.num_input
    semilogy( ...
        0:length(numerical_poly_coefs(input_idx, :))-1, ...
        abs(numerical_poly_coefs(input_idx, :)), ...
        'x');
    hold on
    legend_strs{input_idx} = ...
        sprintf('$$c|\\{x_{n\\neq%i}=0\\}$$', input_idx);
end
xlabel('$$n$$');
ylabel('$$c$$');
legend(legend_strs);
grid on; grid minor;
title('Abs. Value of Numerical Polynomial Coefficients');

% Visualize the theoretical poly coefs
figure;
legend_strs = cell(1, mlp_hyperparams.num_input);

for input_idx = 1:mlp_hyperparams.num_input
    semilogy( ...
        0:length(theoretical_poly_coefs(input_idx, :))-1, ...
        abs(theoretical_poly_coefs(input_idx, :)), ...
        'x');
    hold on
    legend_strs{input_idx} = ...
        sprintf('$$c|\\{x_{n\\neq%i}=0\\}$$', input_idx);
end
xlabel('$$n$$');
ylabel('$$c$$');
legend(legend_strs);
grid on; grid minor;
title('Abs. Value of Theoretical Polynomial Coefficients');

% Visualize the first 10 on the same plot:
legend_strs = cell(1, 2);
n_plot = 12;

for input_idx = 1:mlp_hyperparams.num_input
    figure;
    semilogy( ...
        0:(n_plot-1), ...
        abs(numerical_poly_coefs(input_idx, 1:n_plot)), ...
        'kx', 'MarkerSize', 7);
    hold on;
    semilogy( ...
        0:(n_plot-1), ...
        abs(theoretical_poly_coefs(input_idx, 1:n_plot)), ...
        'ko', 'MarkerSize', 7);
    legend_strs{1} = ...
        sprintf('$$c_n|\\{x_{n\\neq%i}=0\\}$$', input_idx);
    legend_strs{2} = ...
        sprintf('$$c_t|\\{x_{n\\neq%i}=0\\}$$', input_idx);
    xlabel('$$n$$');
    ylabel('$$c$$');
    legend(legend_strs);
    grid on; grid minor;
    title('Theoretical and Numerical Coefs Comparison');
end

end
