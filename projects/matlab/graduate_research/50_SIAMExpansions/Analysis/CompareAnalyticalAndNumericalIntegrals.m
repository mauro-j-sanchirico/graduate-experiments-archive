function CompareAnalyticalAndNumericalIntegrals( ...
    f_analytic_handle,  f_numerical_handle, ...
    j_max, r, dxi, title_str)

x = dxi:dxi:r;

j_list = 1:j_max;

figure;

for idx = 1:length(j_list)
    
    j_idx = j_list(idx);
    fprintf('Analyzing j = %i of %i\n', j_idx, j_max);
        
    y_analytic = f_analytic_handle(j_idx, x);
    
    y_numerical = zeros(size(x));
    
    % Need at least two points to integrate
    for inner_idx = 2:length(y_numerical)
        y_numerical(inner_idx) = ...
            f_numerical_handle(j_idx, x(inner_idx), dxi);
    end
    
    plot(x, y_analytic, 'b', 'linewidth', 6);
    hold on;
    plot(x, y_numerical, 'g', 'linewidth', 2);
    
end

grid on;
grid minor;
xlabel('$$\xi$$');
title(title_str);

end
