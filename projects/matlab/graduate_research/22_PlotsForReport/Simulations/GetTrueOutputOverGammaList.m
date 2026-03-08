function [gamma_list, y_truth] = ...
    GetTrueOutputOverGammaList(x_interrogation, gamma_list)

y_truth = zeros(length(x_interrogation), length(gamma_list));

for gamma_idx = 1:length(gamma_list)
    
    gamma_hidden = gamma_list(gamma_idx);
    y_output = GetTrueOutputY(x_interrogation, gamma_hidden);
    y_truth(:, gamma_idx) = y_output;
    
end

end

