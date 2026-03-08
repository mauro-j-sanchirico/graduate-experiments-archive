function poly_coefs_tanh_modified = GetPolyCoefsTanh()

analysis_params = GetAnalysisParams();
m_expansion_params = GetModifiedExpansionParams();

if analysis_params.gen_new_alphas
    root_type = 1;
    plot_flag = false;
    rho_table = BuildRhoTable( ...
        m_expansion_params.m_index_max, ...
        root_type, plot_flag);

    % Compute modified expansion coefs
    poly_coefs_tanh_modified = GetPolynomialCoefsTanhModifiedExpansion( ...
        m_expansion_params.m_index_max, m_expansion_params.epsilon, ...
        m_expansion_params.dxi, m_expansion_params.max_v, ...
        rho_table, m_expansion_params.numerical_integral_flag);

else
    loaded_coefs = ...
        load('poly_coefs_tanh_modified', 'poly_coefs_tanh_modified');
    poly_coefs_tanh_modified = loaded_coefs.poly_coefs_tanh_modified;   
end

% Visualize and compare results
dv = 0.005;
v = -m_expansion_params.max_v:dv:m_expansion_params.max_v;
y_tanh_modified = polyval(poly_coefs_tanh_modified, v);
y_tanh = tanh(v);
VisualizeTanhModifiedExpansion(v, y_tanh, y_tanh_modified);
save('poly_coefs_tanh_modified', 'poly_coefs_tanh_modified');

end

