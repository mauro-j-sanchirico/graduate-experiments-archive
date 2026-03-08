function VisualizeExpansionCoefs( ...
    poly_coefs_tanh_taylor, poly_coefs_tanh_sum_exp, ...
    poly_coefs_tanh_numerical, poly_coefs_tanh_numerical_odd, ...
    poly_coefs_tanh_modified, m_index_max)

poly_coefs_tanh_taylor = fliplr(poly_coefs_tanh_taylor);
poly_coefs_tanh_sum_exp = fliplr(poly_coefs_tanh_sum_exp);
poly_coefs_tanh_numerical = fliplr(poly_coefs_tanh_numerical);
poly_coefs_tanh_numerical_odd = fliplr(poly_coefs_tanh_numerical_odd);
poly_coefs_tanh_modified = fliplr(poly_coefs_tanh_modified);

poly_coefs_tanh_taylor = poly_coefs_tanh_taylor(1:m_index_max+1);
poly_coefs_tanh_sum_exp = poly_coefs_tanh_sum_exp(1:m_index_max+1);
poly_coefs_tanh_numerical = poly_coefs_tanh_numerical(1:m_index_max+1);
poly_coefs_tanh_numerical_odd = ...
    poly_coefs_tanh_numerical_odd(1:m_index_max+1);
poly_coefs_tanh_modified = poly_coefs_tanh_modified(1:m_index_max+1);

m_index = 0:m_index_max;

% Comparisons
figure;
semilogy(m_index, abs(poly_coefs_tanh_taylor), 'k+', 'linewidth', 1);
hold on;
semilogy(m_index, abs(poly_coefs_tanh_sum_exp), 'k^', 'linewidth', 1)
%semilogy(m_index, abs(poly_coefs_tanh_numerical), 'k.', 'linewidth', 1);
semilogy( ...
    m_index, abs(poly_coefs_tanh_numerical_odd), 'ko', 'linewidth', 1);
semilogy(m_index, abs(poly_coefs_tanh_modified), 'kx', 'linewidth', 1);
grid on;
grid minor;
title('Absolute Value of Expansion Coefficients');
legend('Taylor', 'Sum of Exp.', 'Odds Only', 'Modified');
xlabel('$$m$$')
saveas(gcf, './Images/CoefficientsComparison.png');

end

