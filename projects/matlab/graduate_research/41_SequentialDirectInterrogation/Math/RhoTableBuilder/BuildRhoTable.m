%% BuildRhoTable
%
% @breif Builds a table showing the range of validity of a given partial
% sum of sin(u)
%
% @param[in] m_index_max - The maximum number of partial sum terms to use
% in computing the rho table
%
% @param[in] root_type - When 1 uses the largest, when 2 uses the second
% largest, when 3 uses the third largetest, etc.
%
% @param[in] plot_flag - Makes plots when true
%
% @returns rho_table - Table giving the range of validity for a given
% number of partial sum terms big_m.  The table can be accessed via
% 

function rho_table = BuildRhoTable(m_index_max, root_type, plot_flag)

rho_table = nan(m_index_max, 1);

if plot_flag
    du = 0.01;
    u = 0:du:20;
    
    figure;
    semilogy(u, abs(sin(u)), 'k');
    hold on;
    grid on;
    grid minor;
end

for number_terms_big_m = 1:m_index_max
    
    % Taylor expansion
    sin_taylor_coefs = ...
        GetPolynomialCoefsSinTaylorSeries(number_terms_big_m);
    
    % Get the largest real part of all the roots.  This works better than
    % getting the largest real root with
    % real(sin_taylor_roots(abs(imag(sin_taylor_roots)) < eps));
    
    sin_taylor_roots = roots(sin_taylor_coefs);
    real_sin_taylor_roots = sort(real(sin_taylor_roots), 'descend');
    
    if length(real_sin_taylor_roots) >= root_type
        rho = real(real_sin_taylor_roots(root_type));
        rho_table(number_terms_big_m) = rho;
        
        if plot_flag && number_terms_big_m <= 20
            semilogy( ...
                u, abs(polyval(sin_taylor_coefs, u)), ...
                'k--', 'linewidth', 1);
        end
    end
end

if plot_flag
    
    % finish previous plot
    title('$$\sin(u)$$ and partial sums $$P_M^{TE}\mathrm{\{sin\}}(u)$$');
    xlabel('$$u$$');
    legend( ...
        '$$\sin(u)$$', ' $$P_M^{TE}\mathrm{\{sin\}}(u)$$');
    saveas(gcf, './Images/TaylorExpansionsSin.png')
    
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
        sin_taylor_coefs = ...
            GetPolynomialCoefsSinTaylorSeries(number_terms_big_m);
        
        sin_taylor_roots = roots(sin_taylor_coefs);
        real_sin_taylor_roots = sort(real(sin_taylor_roots), 'descend');
        
        partial_sum_handle = @(u) polyval(sin_taylor_coefs, u);
        real_max = number_terms_big_m + 2;
        imag_max = number_terms_big_m + 2;

        figure;
        PlotInComplexPlane( ...
            partial_sum_handle, real_max, imag_max, du);
        hold on;
        xlabel('$$\mathrm{Re}\{u\}$$');
        ylabel('$$\mathrm{Im}\{u\}$$');
        title_str = sprintf( ...
            '$$P_{%i}^{TE}\\mathrm{\\{sin\\}}(u)$$', ...
            number_terms_big_m);
        title(title_str);
        
        for root_idx = 1:length(sin_taylor_roots)
            real_part = real(sin_taylor_roots(root_idx));
            imag_part = imag(sin_taylor_roots(root_idx));
            plot( ...
                real_part, imag_part, ...
                'kx', 'linewidth', 5, 'MarkerSize', 14);
        end
        
        real_part = real(real_sin_taylor_roots(root_type));
        xline(real_part, 'linewidth', 3);
        xline(-real_part, 'linewidth', 3);
        save_str = sprintf( ...
            './Images/TaylorSinePartialSumRoots%i.png', ...
            number_terms_big_m);
        saveas(gcf, save_str);
    end
end

end
