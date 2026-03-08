%% AnalyzeMuFunction2D
%
% @brief Analyzes the mu function
%
% @param[in] mu_table - the mu function lookup table
%
% @returns void
%

function AnalyzeMuFunction2D(mu_table)

[~, L_size] = size(mu_table);

L_max = L_size - 1;

L = 0:L_max;

figure;

colors = ['b', 'r', 'g', 'c', 'm', 'k'];

for n = 0:5
    plot(L, ComputeMuFunctionLookupTable(n, L, mu_table),...
        'x', ...
        'color', colors(n+1));
    hold on;
end

grid on;

xlabel('l');
ylabel('\mu(n,l)');
title('\mu(n,l) Analysis');
legend('n=0','n=1','n=2','n=3','n=4','n=5');

end

