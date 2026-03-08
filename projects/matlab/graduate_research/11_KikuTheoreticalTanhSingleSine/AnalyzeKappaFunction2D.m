%% AnalyzeKappaFunction2D
%
% @brief Analyzes the Kappa function in a 2D plot
%
% @param[in] kappa_table - the kappa function lookup table
%
% @returns void
%

function AnalyzeKappaFunction2D(kappa_table)

[~, L_size] = size(kappa_table);

L_max = min(L_size - 1, 100);

L = 0:L_max;

figure;

colors = ['b', 'r', 'g', 'c', 'm', 'k'];

for n = 0:5
    k = ComputeKappaFunctionLookupTable( ...
        n, L, kappa_table(:, 1:L_max+1));
    
    plot(L, k,...
        'x', ...
        'color', colors(n+1));
    hold on;
end

grid on;

xlabel('l');
ylabel('K(n,l)');
title('K(n,l) Analysis');
legend('n=0','n=1','n=2','n=3','n=4','n=5');