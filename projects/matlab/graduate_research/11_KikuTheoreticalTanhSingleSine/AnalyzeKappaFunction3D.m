%% AnalyzeKappaFunction3D
%
% @brief Analyzes the Kappa function as a surface over n and L
%
% @param[in] kappa_table - the kappa function lookup table
%
% @returns void
%

function AnalyzeKappaFunction3D(kappa_table)

[n_size, L_size] = size(kappa_table);

n_max = n_size - 1;
L_max = min(L_size - 1, 100);

n = 0:n_max;
L = 0:L_max;

[LL, nn] = meshgrid(L, n);

figure;
plot3(nn, LL, abs(kappa_table(1:n_max+1, 1:L_max+1)), 'kx');
grid on;
grid minor;
xlabel('n');
ylabel('l');
zlabel('|K(n,l)|')
title('3D Analysis of K(n,l)');

end

