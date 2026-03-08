function legend_strings = GetLegendStrings(gamma_list)

legend_strings = cell(size(gamma_list));

for gamma_idx = 1:length(gamma_list)
    
    legend_strings{gamma_idx} = ...
        sprintf('\\gamma = %f', gamma_list(gamma_idx));
    
end

