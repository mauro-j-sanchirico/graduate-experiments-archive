function VisualizeFundamentalMLPs(mlp_params, x)

mlp_hyperparams = GetMLPHyperparams();

big_ni = mlp_hyperparams.num_input;
big_nh = mlp_hyperparams.num_hidden;
output_neuron = 1;

for active_input_ni = 1:big_ni
    
    x_active = x(active_input_ni,:);
        
    fig_handle = figure;
    
    legend_strs = cell(1, big_nh+2);
    f_sum = mlp_params.b_layer1(output_neuron);
    
    % plot the output bias term
    plot(x(active_input_ni,:), f_sum*ones(size(x_active)), 'k--');
    hold on;
    
    legend_strs{1} = sprintf( ...
            '$$b^{\\{1\\}}_{%i}$$', output_neuron);
    
    for hidden_neuron_nh = 1:big_nh
        f_ni_nh = EvalFundamentalMLP( ...
            active_input_ni, hidden_neuron_nh, mlp_params, x);
        plot(x_active, f_ni_nh);
        legend_strs{hidden_neuron_nh+1} = sprintf( ...
            '$$f_{%i,%i}$$', active_input_ni, hidden_neuron_nh);
        hold on;
        f_sum = f_sum + f_ni_nh;
    end
    
    plot(x_active, f_sum, 'k');
    
    grid on;
    grid minor;
    xlabel(sprintf('$$x_%i$$', active_input_ni));
    title(sprintf( ...
        'Fundamental MLPs Contributing to $$y|\\{x_{n\\neq%i}=0\\}$$', ...
        active_input_ni));
    
    legend_strs{big_nh+2} = ...
        sprintf('$$y|\\{x_{n\\neq%i}=0\\}$$', active_input_ni);
    legend(legend_strs);
    
    save_str = sprintf( ...
        'Images/FundamentalMLPsForActiveInput%i.png', active_input_ni);
    saveas(fig_handle, save_str);
    
end

end

