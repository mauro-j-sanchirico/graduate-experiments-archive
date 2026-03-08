%% BuildRhoTable
%
% @breif Builds a table showing the range of validity of a given partial
% sum of sin(u) or a partial sum of cos(u)
%
% @param[in] m_index_max - The maximum number of partial sum terms to use
% in computing the rho table
%
% @param[in] root_type - When 1 uses the largest, when 2 uses the second
% largest, when 3 uses the third largetest, etc.
%
% @param[in] table_type - 'cos' for cosine or 'sin' for sine
%
% @param[in] plot_flag - Makes plots when true
%
% @returns rho_table - Table giving the range of validity for a given
% number of partial sum terms big_m.  The table can be accessed via
% 

function rho_table = BuildRhoTable( ...
    m_index_max, root_type, table_type, plot_flag)

rho_table = nan(m_index_max, 1);

if plot_flag
    du = 0.01;
    u = 0:du:20;

    if strcmp(table_type, 'sin')
        y = abs(sin(u));
    else
        y = abs(cos(u));
    end

    figure;
    semilogy(u, y, 'k');
    hold on;
    grid on;
    grid minor;
end

for number_terms_big_m = 1:m_index_max
    
    % Taylor expansion
    if strcmp(table_type, 'sin')
        partial_sum_coefs = ...
            GetPolynomialCoefsSinTaylorSeries(number_terms_big_m);
    else
        partial_sum_coefs = ...
            GetPolynomialCoefsCosTaylorSeries(number_terms_big_m);
    end
    
    % Get the largest real part of all the roots.  This works better than
    % getting the largest real root with
    % real(partial_sum_roots(abs(imag(partial_sum_roots)) < eps));
    
    partial_sum_roots = roots(partial_sum_coefs);
    real_roots = sort(real(partial_sum_roots), 'descend');
    
    if length(real_roots) >= root_type
        rho = real(real_roots(root_type));
        rho_table(number_terms_big_m) = rho;
        
        if plot_flag && number_terms_big_m <= 20
            semilogy( ...
                u, abs(polyval(partial_sum_coefs, u)), ...
                'k--', 'linewidth', 1);
        end
    end
end

if plot_flag
    
    % finish previous plot
    
    if strcmp(table_type, 'sin')
        title('$$\sin(u)$$ and partial sums $$P_M^{TE}\mathrm{\{sin\}}(u)$$');
        xlabel('$$u$$');
        legend( ...
            '$$\sin(u)$$', ' $$P_M^{TE}\mathrm{\{sin\}}(u)$$');
        saveas(gcf, './Images/TaylorExpansionsSin.png');
    else
        title('$$\cos(u)$$ and partial sums $$P_M^{TE}\mathrm{\{cos\}}(u)$$');
        xlabel('$$u$$');
        legend( ...
            '$$\cos(u)$$', ' $$P_M^{TE}\mathrm{\{cos\}}(u)$$');
        saveas(gcf, './Images/TaylorExpansionsCos.png');
    end
    
    % plot roots with respect to M
    figure;
    m_indicies = 1:length(rho_table);
    plot(m_indicies, rho_table, 'ko');
    grid on;
    grid minor;
    xlabel('$$M$$');
    title('Range of validity $$\rho(M)$$');
    saveas(gcf, './Images/RangeOfValidityRhoM.png');
    
    % plot partial sums in complex plane
    for number_terms_big_m = 1:9
        
        % Taylor expansion
        if strcmp(table_type, 'sin')
            partial_sum_coefs = ...
                GetPolynomialCoefsSinTaylorSeries(number_terms_big_m);
        else
            partial_sum_coefs = ...
                GetPolynomialCoefsCosTaylorSeries(number_terms_big_m);
        end
        
        partial_sum_roots = roots(partial_sum_coefs);
        real_roots = sort(real(partial_sum_roots), 'descend');
        
        partial_sum_handle = @(u) polyval(partial_sum_coefs, u);
        real_max = number_terms_big_m + 2;
        imag_max = number_terms_big_m + 2;

        figure;
        PlotInComplexPlane( ...
            partial_sum_handle, real_max, imag_max, du);
        hold on;
        xlabel('$$\mathrm{Re}\{u\}$$');
        ylabel('$$\mathrm{Im}\{u\}$$');
        
        if strcmp(table_type, 'sin')
            title_str = sprintf( ...
                '$$\\log_{10}(|P_{%i}^{TE}\\mathrm{\\{sin\\}}(u)|)$$', ...
                number_terms_big_m);
        else
            title_str = sprintf( ...
                '$$\\log_{10}(|P_{%i}^{TE}\\mathrm{\\{cos\\}}(u)|)$$', ...
                number_terms_big_m);
        end
        
        title(title_str);
        
        for root_idx = 1:length(partial_sum_roots)
            real_part = real(partial_sum_roots(root_idx));
            imag_part = imag(partial_sum_roots(root_idx));
            plot( ...
                real_part, imag_part, ...
                'kx', 'linewidth', 5, 'MarkerSize', 14);
        end

        if length(real_roots) > 0
            real_part = real(real_roots(root_type));
            xline(real_part, 'linewidth', 3);
            xline(-real_part, 'linewidth', 3);
        end
        
        if strcmp(table_type, 'sin')
            save_str = sprintf( ...
                './Images/TaylorSinePartialSumRoots%i.png', ...
                number_terms_big_m);
        else
            save_str = sprintf( ...
                './Images/TaylorCosinePartialSumRoots%i.png', ...
                number_terms_big_m);
        end
        
        saveas(gcf, save_str);
    end
end

end
