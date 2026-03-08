%% Direct Interrogation with Equivalency Check
%% Interrogate by optimizing to meet recorded points

clc; clear; close all;
RunInitializationRoutine

set(groot, 'defaultAxesFontSize', 18);


%% Tanh with v_max = 2

max_v = 2;

analysis_params = GetAnalysisParams();
m_expansion_params = GetModifiedExpansionParams();

root_type = 1;
plot_flag = false;

rho_table = BuildRhoTable( ...
    m_expansion_params.m_index_max, ...
    root_type, plot_flag);

poly_coefs_tanh_modified1 = GetPolynomialCoefsTanhModifiedExpansion( ...
    m_expansion_params.m_index_max, m_expansion_params.epsilon, ...
    m_expansion_params.dxi, max_v, ...
    rho_table, m_expansion_params.numerical_integral_flag);

% Visualize and compare results
dv = 0.005;
v = -max_v:dv:max_v;
y_tanh_modified = polyval(poly_coefs_tanh_modified1, v);
y_tanh = tanh(v);
error = abs(y_tanh - y_tanh_modified);

figure('Renderer', 'painters', 'Position', [10 60 900 600]);

subplot(2,1,1)
plot(v, y_tanh_modified, 'k-');
ylim([min(y_tanh_modified)*1.2 max(y_tanh_modified)*1.2]);
grid on; grid minor;
xlabel('$$v$$');
title(' $\tilde{y}(v) = \sum_{m=1}^{M}\alpha_{2m-1}v^{2m-1}, \quad v_{MAX} = 2$');

subplot(2,1,2)
semilogy(v, error, 'k');
grid on; grid minor;
xlabel('$$v$$');
title('$| \tilde{y}(v) - \tanh(v) |$');
saveas(gcf, './Images/ModifiedExpansionVmax2_M40.png');


%% Tanh with v_max = 5

max_v = 5;

analysis_params = GetAnalysisParams();
m_expansion_params = GetModifiedExpansionParams();

root_type = 1;
plot_flag = false;

rho_table = BuildRhoTable( ...
    m_expansion_params.m_index_max, ...
    root_type, plot_flag);

poly_coefs_tanh_modified1 = GetPolynomialCoefsTanhModifiedExpansion( ...
    m_expansion_params.m_index_max, m_expansion_params.epsilon, ...
    m_expansion_params.dxi, max_v, ...
    rho_table, m_expansion_params.numerical_integral_flag);

% Visualize and compare results
dv = 0.005;
v = -max_v:dv:max_v;
y_tanh_modified = polyval(poly_coefs_tanh_modified1, v);
y_tanh = tanh(v);
error = abs(y_tanh - y_tanh_modified);

figure('Renderer', 'painters', 'Position', [10 60 900 600]);

subplot(2,1,1)
plot(v, y_tanh_modified, 'k-');
ylim([min(y_tanh_modified)*1.2 max(y_tanh_modified)*1.2]);
grid on; grid minor;
xlabel('$$v$$');
title(' $\tilde{y}(v) = \sum_{m=1}^{M}\alpha_{2m-1}v^{2m-1}, \quad v_{MAX} = 5$');

subplot(2,1,2)
semilogy(v, error, 'k');
grid on; grid minor;
xlabel('$$v$$');
title('$| \tilde{y}(v) - \tanh(v) |$');
saveas(gcf, './Images/ModifiedExpansionVmax5M40.png');


%% Plot convergence surface

max_v1 = 2;
max_v2 = 5;

% Limits of v
dv = 0.01;
vmin = -6;
vmax = 6;

% Limits of M
big_m_max = 80;

v = vmin:dv:vmax;
big_m_range = 1:big_m_max;

% Initialize error surfaces
modified_error_surface1 = zeros(length(big_m_range), length(v));
modified_error_surface2 = zeros(length(big_m_range), length(v));
modified_error_surface3 = zeros(length(big_m_range), length(v));

y_tanh = tanh(v);

for number_terms_big_m = big_m_range

    fprintf('Processing M = %i of %i\n', number_terms_big_m, big_m_max);

    % Only odd coefficients contribute, so 80 terms in the polynomial
    % is only equivalent to 40 terms in the modified sum
    number_terms_big_m_modified = ceil(number_terms_big_m/2);
    
    % Get modified expansion error surface for max_v1
    poly_coefs_tanh_modified1 = GetPolynomialCoefsTanhModifiedExpansion( ...
        number_terms_big_m_modified, m_expansion_params.epsilon, ...
        m_expansion_params.dxi, max_v1, ...
        rho_table, m_expansion_params.numerical_integral_flag);
    
    y_tanh_modified = polyval(poly_coefs_tanh_modified1, v);
    
    error_modified = abs(y_tanh - y_tanh_modified);
    modified_error_surface1(number_terms_big_m, :) = ...
        log10(error_modified + m_expansion_params.epsilon);
    
    % Get modified expansion error surface for max_v2
    poly_coefs_tanh_modified2 = GetPolynomialCoefsTanhModifiedExpansion( ...
        number_terms_big_m_modified, m_expansion_params.epsilon, ...
        m_expansion_params.dxi, max_v2, ...
        rho_table, m_expansion_params.numerical_integral_flag);
    
    y_tanh_modified = polyval(poly_coefs_tanh_modified2, v);
    
    error_modified = abs(y_tanh - y_tanh_modified);
    modified_error_surface2(number_terms_big_m, :) = ...
        log10(error_modified + m_expansion_params.epsilon);

end


%% Plot Convergence Surface

[v_mesh, big_m_mesh] = meshgrid(v, big_m_range);

% Get common color limits for all plots
surfaces = [ ...
    modified_error_surface1; ...
    modified_error_surface2];

min_surf = min(min(surfaces));
max_surf = max(max(surfaces));

figure('Renderer', 'painters', 'Position', [100 80 1100 600])

levels = [-20 -10:5:25];

subplot(211);
    [C,h] = contourf(v_mesh, big_m_mesh, modified_error_surface1, levels, 'showtext', 'on');
    clabel(C, h, 'FontSize', 16, 'labelspacing', 700);
    shading interp;
    view([0 90]); xlim([vmin vmax]); ylim([1, big_m_max]);
    xlabel('$$v$$'); ylabel('N. Terms');
    title(sprintf('$$\\log_{10}| \\tilde{y}(v) - \\tanh(v) |, \\quad v_{MAX} = %.1f$$', max_v1));
    colorbar;
    caxis([min_surf max_surf]); caxis manual;
    colormap gray; clims = caxis;
    cmean = mean(clims); cdist = clims(2) - clims(1); cdist = cdist*2;
    clims(1) = cmean - cdist*0.5; clims(2) = cmean + cdist*0.5;
    caxis(clims);
    
levels = [-20 -4:2:2];

subplot(212);
    [C,h] = contourf(v_mesh, big_m_mesh, modified_error_surface2, levels, 'showtext', 'on');
    clabel(C, h, 'FontSize', 16, 'labelspacing', 700);
    shading interp;
    view([0 90]); xlim([vmin vmax]); ylim([1, big_m_max]);
    xlabel('$$v$$'); ylabel('N. Terms');
    title(sprintf('$$\\log_{10}| \\tilde{y}(v) - \\tanh(v) |, \\quad v_{MAX} = %.1f$$', max_v2));
    colorbar;
    caxis([min_surf max_surf]); caxis manual;
    colormap gray; clims = caxis;
    cmean = mean(clims); cdist = clims(2) - clims(1); cdist = cdist*2;
    clims(1) = cmean - cdist*0.5; clims(2) = cmean + cdist*0.5;
    caxis(clims);
    
saveas(gcf, 'Images/ConvergenceSurfacesTanh.png')

