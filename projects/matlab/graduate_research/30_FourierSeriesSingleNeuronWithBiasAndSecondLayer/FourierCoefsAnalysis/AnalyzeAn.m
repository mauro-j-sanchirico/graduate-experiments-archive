function an = AnalyzeAn( ...
    gamma10_layer0_grid_vector, gamma11_layer0_grid_vector, ...
    gamma10_layer0_grid, gamma11_layer0_grid, ...
    gamma11_layer1, alpha_coefs, number_partial_sum_terms_ns, ...
    n_fourier, omega)


fprintf('\nComputing a(%i)...\n', n_fourier);

an = zeros( ...
    length(gamma11_layer0_grid_vector), ...
    length(gamma10_layer0_grid_vector));

for i = 1:length(gamma10_layer0_grid_vector)
    
    fprintf( ...
        '   Iteration %i/%i\n', i, length(gamma10_layer0_grid_vector));
    
    for j = 1:length(gamma11_layer0_grid_vector)
        
        gamma10_layer0 = gamma10_layer0_grid(j,i);
        gamma11_layer0 = gamma11_layer0_grid(j,i);
        an(j,i) = ComputeAn( ...
            gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
            alpha_coefs, number_partial_sum_terms_ns, n_fourier, omega);
        
    end
end

end

