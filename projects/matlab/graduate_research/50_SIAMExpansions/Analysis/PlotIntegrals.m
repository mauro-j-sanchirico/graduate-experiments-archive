function PlotIntegrals(f_handle, j_max, r, dxi, title_str)

xi = [-r:dxi:-dxi dxi:dxi:r];

j_list = 0:j_max;

figure;

for idx = 1:length(j_list)
    
    j_idx = j_list(idx);
    fprintf('Analyzing j = %i of %i\n', j_idx, j_max);
        
    y = f_handle(j_idx, xi);
    
    plot(xi, y, 'k');
    hold on;
    
end

grid on;
grid minor;
xlabel('$$\xi$$');
title(title_str);

end
