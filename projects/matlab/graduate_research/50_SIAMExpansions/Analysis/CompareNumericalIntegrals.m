function CompareNumericalIntegrals( ...
    f_numerical_handle1,  f_numerical_handle2, ...
    j_max, r, dxi, title_str)

x = dxi:dxi:r;

j_list = 1:j_max;

figure;

for idx = 1:length(j_list)
    
    j_idx = j_list(idx);
    fprintf('Analyzing j = %i of %i\n', j_idx, j_max);
    
    y_numerical1 = zeros(size(x));
    y_numerical2 = zeros(size(x));
    
    % Need at least two points to integrate
    for inner_idx = 2:length(y_numerical1)
        y_numerical1(inner_idx) = ...
            f_numerical_handle1(j_idx, x(inner_idx), dxi);
    end
    
    % Need at least two points to integrate
    for inner_idx = 2:length(y_numerical2)
        y_numerical2(inner_idx) = ...
            f_numerical_handle2(j_idx, x(inner_idx), dxi);
    end
    
    plot(x, y_numerical1, 'b', 'linewidth', 6);
    hold on;
    plot(x, y_numerical2, 'g', 'linewidth', 2);
    
end

grid on;
grid minor;
xlabel('$$\xi$$');
title(title_str);

end
