%% AnalyzeQFunction3D
%
% @brief Analyzes the q function as a surface over m and L
%
% @param[in] q_table - the mu function lookup table
%
% @returns void
%

function AnalyzeQFunction3D(q_table)

[m_size, L_size] = size(q_table);

m_max = m_size - 1;
L_max = L_size - 1;

mm = 0:m_max;
L = 0:L_max;

[LL, nn] = meshgrid(L, mm);

figure;
plot3(nn, LL, log10(abs(q_table)), 'kx');
grid on;
grid minor;
xlabel('m');
ylabel('l');
zlabel('log_{10}(|q(m,l)|)')
title('3D Analysis of q(m,l) - need large L to Converge wrt. m');
view([-164 6]);
end

