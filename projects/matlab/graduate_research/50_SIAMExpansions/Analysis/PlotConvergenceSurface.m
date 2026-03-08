function PlotConvergenceSurface( ...
    f_true, f_partial_sum, big_n_max, r, ...
    xlabel_str, title_str)

dx = 0.01;
epsilon = eps;
x = -r:dx:r;
big_n_range = 0:big_n_max;
y_true = f_true(x);

% Initialize error surface
error_surface = zeros(length(big_n_range+1), length(x));

for idx = 1:length(big_n_range)
    
    big_n = big_n_range(idx);
    fprintf('Processing N = %i of %i\n', big_n, big_n_max);
    y_partial_sum = f_partial_sum(big_n, x);
    error_modified = abs(y_true - y_partial_sum);
    error_surface(idx, :) = ...
        log10(error_modified + epsilon);
    
end

[x_mesh, big_n_mesh] = meshgrid(x, big_n_range);

figure('Renderer', 'painters', 'Position', [100 80 1100 600])

[C, h] = contourf(x_mesh, big_n_mesh, error_surface, 'showtext', 'on');
shading interp;
view([0 90]); xlim([-r r]); ylim([0, big_n_max]);
xlabel(xlabel_str);
ylabel('N. Terms');
title(title_str);
colorbar;

clabel(C, h, 'FontSize', 15, 'Color', 'k')
    
end
