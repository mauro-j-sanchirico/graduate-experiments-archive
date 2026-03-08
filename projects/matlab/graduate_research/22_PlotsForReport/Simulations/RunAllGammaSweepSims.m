function [input, errors] = RunAllGammaSweepSims()

design_flags = GetDesignFlags();

input = design_flags.gamma_sweep;

% Simulate truth for each gamma
[~, y_truth] = GetTrueOutputOverGammaList( ...
    design_flags.x_interrogation, input);

% Simulate output using Taylor Series expansion
[~, y_taylor_fourier] = ...
    GetTaylorFourierOutputOverGammaList( ...
        design_flags.x_interrogation, input);

% Simulate output using sum of exponentials expansion
[~, y_exponential_fourier] = ...
    GetExponentialFourierOutputOverGammaList( ...
        design_flags.x_interrogation, input);

% Generate output using modified expansion
[~, y_modified_fourier] = ...
    GetModifiedFourierOutputOverGammaList( ...
        design_flags.x_interrogation, design_flags.gamma_sweep);
    
errors.taylor_fourier = mean((y_truth - y_taylor_fourier).^2);
errors.exponential_fourier = mean((y_truth - y_exponential_fourier).^2);
errors.modified_fourier = mean((y_truth - y_modified_fourier).^2);

end
