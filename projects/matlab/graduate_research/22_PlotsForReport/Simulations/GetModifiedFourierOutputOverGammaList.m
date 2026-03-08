function [gamma_list, y_modified_fourier] = ...
    GetModifiedFourierOutputOverGammaList(x_interrogation, gamma_list)

design_flags = GetDesignFlags();

y_modified_fourier = zeros(length(x_interrogation), length(gamma_list));

for gamma_idx = 1:length(gamma_list)
    
    gamma_hidden = gamma_list(gamma_idx);
    y_output = GetModifiedFourierOutputY( ...
        gamma_hidden, ...
        design_flags.modified_number_of_harmonics_N, ...
        design_flags.modified_number_of_taylor_series_terms_M, ...
        design_flags.psi);
    y_modified_fourier(:, gamma_idx) = y_output;    
end
