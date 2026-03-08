function PlotConvergenceSurfaces()

% Sum exp expansion auxilliary parameters
l_index_max = 4;

% Numerical expansion auxilliary parameters
dv_numerical = 1e-5;
vmin_numerical = -4;
vmax_numerical = 4;
num_points_numerical = length(vmin_numerical:dv_numerical:vmax_numerical)
fit_type = 'odd';

% Modified expansion set up and auxilliary parameters
m_index_max = 60;
root_type = 1;
plot_flag = false;
rho_table = BuildRhoTable(m_index_max, root_type, plot_flag);
epsilon = eps;    % Small number used to compute limits (use machine eps)
dxi = 1e-5;       % Differential used for approximate integrals
max_v = 4.0;      % Maximum expected input
numerical_integral_flag = true; % True - faster than symbolic integrals

% Limits of v
dv = 0.01;
vmin = -7;
vmax = 7;

% Limits of M
big_m_max = 80;

v = vmin:dv:vmax;
big_m_range = 1:big_m_max;

% Initialize error surfaces
taylor_error_surface = zeros(length(big_m_range), length(v));
sumexp_error_surface = zeros(length(big_m_range), length(v));
oddsonly_error_surface = zeros(length(big_m_range), length(v));
modified_error_surface = zeros(length(big_m_range), length(v));

y_tanh = tanh(v);

for number_terms_big_m = big_m_range

    fprintf('Processing M = %i of %i\n', number_terms_big_m, big_m_max);
    
    % Adjust the indicies so that all polynomials will be the same size
    % and no fits will have more terms than the others.
    number_terms_big_m_taylor = ceil(number_terms_big_m/2);
    number_terms_big_m_sumexp = number_terms_big_m - 1;
    if mod(number_terms_big_m, 2) == 1
        number_terms_odd_expansion = number_terms_big_m - 1;
    else
        number_terms_odd_expansion = number_terms_big_m;
    end
    number_terms_big_m_modified = number_terms_big_m_taylor;
    
    % Get Taylor expansion error surface
    poly_coefs_tanh_taylor = ...
       GetPolynomialCoefsTanhTaylorSeries(number_terms_big_m_taylor);
    y_tanh_taylor = polyval(poly_coefs_tanh_taylor, v);
    error_taylor = abs(y_tanh - y_tanh_taylor);
    taylor_error_surface(number_terms_big_m, :) = ...
        log10(error_taylor + epsilon);
    
    % Get sum exp expansion error surface
    poly_coefs_tanh_sum_exp = GetPolynomialCoefsTanhSumExp( ...
        number_terms_big_m_sumexp, l_index_max);
    y_tanh_sumexp = sign(v).*polyval(poly_coefs_tanh_sum_exp, abs(v));
    error_sumexp = abs(y_tanh - y_tanh_sumexp);
    sumexp_error_surface(number_terms_big_m, :) = ...
        log10(error_sumexp + epsilon);
    
    poly_coefs_tanh_numerical_odd = ComputeTanhNumericalCoefs( ...
        dv_numerical, vmin_numerical, vmax_numerical, ...
        number_terms_odd_expansion, 'odd');
    
    y_tanh_numerical_odd = polyval(poly_coefs_tanh_numerical_odd, v);
    
    error_oddsonly = abs(y_tanh - y_tanh_numerical_odd);
    oddsonly_error_surface(number_terms_big_m, :) = ...
        log10(error_oddsonly + epsilon);
    
    % Get modified expansion error surface
    poly_coefs_tanh_modified = GetPolynomialCoefsTanhModifiedExpansion( ...
        number_terms_big_m_modified, epsilon, dxi, max_v, ...
        rho_table, numerical_integral_flag);
    
    y_tanh_modified = polyval(poly_coefs_tanh_modified, v);
    
    error_modified = abs(y_tanh - y_tanh_modified);
    modified_error_surface(number_terms_big_m, :) = ...
        log10(error_modified + epsilon);
    
end

[v_mesh, big_m_mesh] = meshgrid(v, big_m_range);

% Get common color limits for all plots
top_surfaces = [ ...
    taylor_error_surface;
    sumexp_error_surface];

bottom_surfaces = [ ...
    oddsonly_error_surface;
    modified_error_surface];

min_top = min(min(top_surfaces));
max_top = max(max(top_surfaces));

min_bottom = min(min(bottom_surfaces));
max_bottom = max(max(bottom_surfaces));

%%

figure('Renderer', 'painters', 'Position', [100 80 1100 600])

subplot(221);
    contourf(v_mesh, big_m_mesh, taylor_error_surface, 'showtext', 'on');
    shading interp;
    view([0 90]); xlim([vmin vmax]); ylim([1, big_m_max]);
    xlabel('$$v$$'); ylabel('N. Terms');
    title('$$\log_{10}(|P_M^{TE}\{\tanh\}(v)- \tanh(v)|)$$');
    colorbar;
    caxis([min_top max_top]); caxis manual;

subplot(222);
    contourf(v_mesh, big_m_mesh, sumexp_error_surface, 'showtext', 'on');
    shading interp;
    view([0 90]); xlim([vmin vmax]); ylim([1, big_m_max]);
    xlabel('$$v$$'); ylabel('N. Terms');
    title('$$\log_{10}(|P_{M,4}^{SE}\{\tanh\}(v)- \tanh(v)|)$$');
    colorbar;
    caxis([min_top max_top]); caxis manual;

subplot(223);
    contourf(v_mesh, big_m_mesh, oddsonly_error_surface, 'showtext', 'on');
    shading interp;
    view([0 90]); xlim([vmin vmax]); ylim([1, big_m_max]);
    xlabel('$$v$$'); ylabel('N. Terms');
    title('$$\log_{10}(|P_{M,80001}^{NEO}\{\tanh\}(v)- \tanh(v)|)$$');
    colorbar;
    caxis([min_bottom max_bottom]); caxis manual;

subplot(224);
    contourf(v_mesh, big_m_mesh, modified_error_surface, 'showtext', 'on');
    shading interp; 
    view([0 90]); xlim([vmin vmax]); ylim([1, big_m_max]);
    xlabel('$$v$$'); ylabel('N. Terms');
    title('$$\log_{10}(|P_M^{ME}\{\tanh\}(v)- \tanh(v)|)$$');
    colorbar;
    caxis([min_bottom max_bottom]); caxis manual;

saveas(gcf, 'Images/ConvergenceSurfaces.png')

end

