function VisualizeInterrogationPolynomials(mlp_params, alpha_coefs, x)

mlp_hyperparams = GetMLPHyperparams();

big_ni = mlp_hyperparams.num_input;

for active_input_ni = 1:big_ni
    
    fig_handle = figure;

    f_sum = EvalInterrogationPolynomial( ...
        active_input_ni, mlp_params, alpha_coefs, x);
    
    plot(x(active_input_ni,:), f_sum, 'k');
    
    grid on;
    grid minor;
    xlabel(sprintf('$$x_%i$$', active_input_ni));
    title(sprintf( ...
        'Fundamental MLPs Contributing to $$y|x_{n\\neq%i}=0$$', ...
        active_input_ni));
    
    saveas( ...
        fig_handle, ...
        sprintf('Images/EvalInterrogationPolynomialsForActiveInput%i.png', active_input_ni));
    
end

end

