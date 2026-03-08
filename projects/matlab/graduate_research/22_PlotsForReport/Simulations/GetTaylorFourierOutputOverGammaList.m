function [gamma_list, y_taylor_fourier] = ...
    GetTaylorFourierOutputOverGammaList(x_interrogation, gamma_list)

design_flags = GetDesignFlags();

y_taylor_fourier = zeros(length(x_interrogation), length(gamma_list));

for gamma_idx = 1:length(gamma_list)
    
    gamma_hidden = gamma_list(gamma_idx);
    y_output = GetTaylorFourierOutputY( ...
        gamma_hidden, ...
        design_flags.taylor_number_of_harmonics_N, ...
        design_flags.taylor_number_of_taylor_series_terms_M, ...
        design_flags.psi);
    y_taylor_fourier(:, gamma_idx) = y_output;
    
end

end

