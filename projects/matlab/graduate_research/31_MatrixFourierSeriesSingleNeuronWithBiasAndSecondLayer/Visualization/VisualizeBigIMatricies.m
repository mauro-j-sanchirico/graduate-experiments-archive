function VisualizeBigIMatricies( ...
    big_i_a0_vector, big_i_an_matrix, big_i_bn_matrix, ...
    number_fourier_coefs_n, number_partial_sum_terms_ns)

n_gridv = 1:number_fourier_coefs_n;
k_gridv = 0:(2*number_partial_sum_terms_ns-1);

[n_grid, k_grid] = meshgrid(k_gridv, n_gridv);

min_val = min([min(min(big_i_an_matrix)) min(min(big_i_bn_matrix))]);
max_val = max([max(max(big_i_an_matrix)) max(max(big_i_bn_matrix))]);

figure;
surf(n_grid, k_grid, big_i_an_matrix, 'edgecolor', 'none');
xlabel('$$n = 1 ... N_f$$');
ylabel('$$k = 0 ... 2N_S - 1$$');
title('$$I_{an}$$ Matrix');
view([0 90]);
caxis([min_val, max_val]);
colorbar;

figure;
surf(n_grid, k_grid, big_i_bn_matrix, 'edgecolor', 'none');
xlabel('$$n = 1 ... N_f$$');
ylabel('$$k = 0 ... 2N_S - 1$$');
title('$$I_{bn}$$ Matrix');
view([0 90]);
caxis([min_val, max_val]);
colorbar;

k = 0:(number_partial_sum_terms_ns - 1);

figure;
bar(k, big_i_a0_vector);
xlabel('$$k = 0 ... N_S - 1$$');
title('$$I_{a0}$$ Vector');
grid on;
grid minor;

end

