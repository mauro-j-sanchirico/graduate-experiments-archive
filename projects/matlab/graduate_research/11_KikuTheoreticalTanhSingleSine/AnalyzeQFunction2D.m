%% AnalyzeQFunction2D
%
% @brief Analyzes the q function
%
% @param[in] q_table - the q function lookup table
%
% @returns void
%

function AnalyzeQFunction2D(q_table)

[m_size, ~] = size(q_table);

m_max = m_size - 1;

m = 0:m_max;

figure;

colors = ['b', 'r', 'g', 'c', 'm', 'k'];

for L = 0:5
    plot(m, ComputeQFunctionLookupTable(m, L, q_table),...
        'x', ...
        'color', colors(L+1));
    hold on;
end

grid on;

xlabel('m');
ylabel('q(m,l)');
title('q(m,l) Analysis');
legend('l=0','l=1','l=2','l=3','l=4','l=5');

end

