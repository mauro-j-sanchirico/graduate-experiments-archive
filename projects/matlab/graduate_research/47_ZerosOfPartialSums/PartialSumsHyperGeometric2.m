clc; clear; close all;

addpath('./Math/RhoTableBuilder/');

figure;
x = 0:0.05:10;

big_m_index_min = 0;
big_m_index_max = 10;
big_m_list = big_m_index_min:big_m_index_max-1;

root_type = 1;
plot_flag = false;
rho_cos_table = BuildRhoTable( ...
    big_m_index_max, root_type, 'cos', plot_flag);

rho = zeros(size(big_m_list));
intersect_val = zeros(size(big_m_list));

for idx = 1:length(big_m_list)
    
    big_m = big_m_list(idx);
    
    fprintf('M = %i / %i\n', big_m, big_m_index_max)
    
    % Compute the partial sum
    cosM = zeros(size(x));
    for m = 0:big_m
        term = (-1)^m * x.^(2*m+1) ./ factorial(2*m+1);
        cosM = cosM + term;
    end

    % Compute the partial sum from the hypergeometric function
    fp =  x.^(2*big_m+3) ./ factorial(2*big_m + 3);
    fh = hypergeom(1, [big_m+2, big_m + 5/2], -x.^2./4);
    cosM_formula = (-1)^big_m*fp.*fh + sin(x);
    
    q = abs(fp - fh);
    %q = abs(fp - 1);
    [val, min_idx] = min(q);
    
    rho(idx) = x(min_idx);
    intersect_val(idx) = fp(min_idx);
    
    plot(x, fh, 'b', 'linewidth', 1);
    hold on
    plot(x, fp,  'r', 'linewidth', 1);
    plot(x, sin(x), 'k', 'linewidth', 1);
    plot(x, (-1)^big_m * cosM_formula, 'g', 'linewidth', 1);
    plot(x, cos(x), 'y', 'linewidth', 1);
    plot(rho_cos_table(idx), cos(rho_cos_table(idx)), 'kx');
    %semilogy(x, q,  'k', 'linewidth', 1);
    ylim([-2 2]);
    
end

figure;
plot(rho, 'kx')

% Compare to the roots rho table
figure;
plot(big_m_list, rho, 'kx')
hold on;
plot(big_m_list, rho_cos_table, 'ko');
%plot(1 + (M*factorial((2*big_m_list + 2))).^(1./(2*big_m_list+2)))
grid on; grid minor;

figure;
plot(big_m_list, intersect_val);
