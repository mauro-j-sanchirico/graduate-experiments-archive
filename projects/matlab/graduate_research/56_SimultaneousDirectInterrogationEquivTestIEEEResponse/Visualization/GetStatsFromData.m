function [xu, y_means, y_std_devs] = GetStatsFromData(x, y)

xu = unique(x);

y_means = zeros(size(xu));
y_std_devs = zeros(size(xu));

for idx = 1:length(xu)
    
    selection = x == xu(idx);
    
    x_selected = x(selection);
    y_selected = y(selection);
    
    y_means(idx) = mean(y_selected);
    y_std_devs(idx) = std(y_selected);

end

end
