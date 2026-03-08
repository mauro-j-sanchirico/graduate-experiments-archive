%% AnalyzeMuFunction3D
%
% @brief Analyzes the mu function as a surface over n and L
%
% @param[in] mu_table - the mu function lookup table
%
% @returns void
%

function AnalyzeMuFunction3D(mu_table)

[n_size, L_size] = size(mu_table);

n_max = n_size - 1;
L_max = L_size - 1;

n = 0:n_max;
L = 0:L_max;

[LL, nn] = meshgrid(L, n);

figure;
plot3(nn, LL, mu_table, 'kx');
grid on;
grid minor;
xlabel('n');
ylabel('l');
zlabel('\mu(n,l)')
title('3D Analysis of \mu(n,l)');

end

