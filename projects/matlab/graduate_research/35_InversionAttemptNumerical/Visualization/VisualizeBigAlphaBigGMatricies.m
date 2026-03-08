function VisualizeBigAlphaBigGMatricies( ...
    big_alpha_matrix, big_g_matrix, number_partial_sum_terms_ns)

k_gridv = 0:(2*number_partial_sum_terms_ns - 1);
m_gridv = 1:number_partial_sum_terms_ns;

[k_grid, m_grid] = meshgrid(m_gridv, k_gridv);

min_alpha_val = min(min(big_alpha_matrix));
max_alpha_val = max(max(big_alpha_matrix));

min_alpha_log_val = min(min(log10(abs(big_alpha_matrix))));
max_alpha_log_val = max(max(log10(abs(big_alpha_matrix))));

min_g_val = min(min(big_g_matrix));
max_g_val = max(max(big_g_matrix));

min_g_log_val = min(min(log10(abs(big_g_matrix))));
max_g_log_val = max(max(log10(abs(big_g_matrix))));

% Big Alpha Plots
figure;
surf(m_grid, k_grid, big_alpha_matrix, 'edgecolor', 'none');
xlabel('$$m = 1 ... N_S$$');
ylabel('$$k = 0 ... 2N_S - 1$$');
title('$$A$$ Matrix');
view([0 90]);
caxis([min_alpha_val, max_alpha_val]);
colorbar;

figure;
surf(m_grid, k_grid, log10(abs(big_alpha_matrix)), 'edgecolor', 'none');
xlabel('$$m = 1 ... N_S$$');
ylabel('$$k = 0 ... 2N_S - 1$$');
title('$$\log_{10}(|A|)$$ Matrix');
view([0 90]);
caxis([min_alpha_log_val, max_alpha_log_val]);
colorbar;

figure;
surf(m_grid, k_grid, sign(big_alpha_matrix), 'edgecolor', 'none');
xlabel('$$m = 1 ... N_S$$');
ylabel('$$k = 0 ... 2N_S - 1$$');
title('sign$$(A)$$ Matrix');
view([0 90]);
caxis([-1, 1]);
colormap('gray')
colorbar;

% Big G Plots
figure;
surf(m_grid, k_grid, big_g_matrix, 'edgecolor', 'none');
xlabel('$$m = 1 ... N_S$$');
ylabel('$$k = 0 ... 2N_S - 1$$');
title('$$G$$ Matrix');
view([0 90]);
caxis([min_alpha_val, max_alpha_val]);
colorbar;

figure;
surf(m_grid, k_grid, log10(abs(big_g_matrix)), 'edgecolor', 'none');
xlabel('$$m = 1 ... N_S$$');
ylabel('$$k = 0 ... 2N_S - 1$$');
title('$$\log_{10}(|G|)$$ Matrix');
view([0 90]);
caxis([min_alpha_log_val, max_alpha_log_val]);
colorbar;

figure;
surf(m_grid, k_grid, sign(big_g_matrix), 'edgecolor', 'none');
xlabel('$$m = 1 ... N_S$$');
ylabel('$$k = 0 ... 2N_S - 1$$');
title('sign$$(G)$$ Matrix');
view([0 90]);
caxis([-1, 1]);
colormap('gray')
colorbar;

end

