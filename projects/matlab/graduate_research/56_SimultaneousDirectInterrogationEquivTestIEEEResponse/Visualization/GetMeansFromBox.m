function [x,y] = GetMeansFromBox(h_axis)

h = findobj(h_axis, 'Tag', 'Box');

x = zeros(1, length(h));
y = zeros(1, length(h));

for idx = 1:length(h)
    
    x_data = h(idx).XData;
    y_data = h(idx).YData;
    
    min(x_data)
    
    x(idx) = (max(x_data) + min(x_data))/2;
    y(idx) = (max(y_data) + min(y_data))/2;

end

