function PlotCoefs(f_get_coefs, big_n_max, title_str)

big_n_list = 0:big_n_max;
coefs = f_get_coefs(big_n_list);

figure('Renderer', 'painters', 'Position', [10 60 800 600]);
semilogy(big_n_list, abs(coefs), 'kx', 'markersize', 15);
grid on;
grid minor;
xlabel('$$N$$');
ylabel('$$|C_N|$$');
title(title_str);

end
