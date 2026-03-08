function design_flags = GetDesignFlags()

% Independent variable
dpsi = 0.01;
design_flags.psi = 0:dpsi:2*pi;

% Interrogation signal
design_flags.x_interrogation = sin(design_flags.psi);

% Gamma lists
design_flags.small_gamma_list = [0.1 0.7 pi/2];
design_flags.med_gamma_list = [0.1 0.7 pi/2 3];
design_flags.all_gamma_list = [0.1 0.7 pi/2 3 5];

% Gamma sweeps
n_sweep = 40;
design_flags.gamma_sweep = linspace(0.1, 8, n_sweep);

% New table generation
design_flags.new_mu_table = true;
design_flags.new_q_table = true;
design_flags.new_lambda_table = true;

% Configurations for Lambda expansion
attempt_to_estimate_large_gains = false;
attempt_to_estimate_small_gains = true;
compromise = false;

% Taylor expansion parameters
design_flags.taylor_number_of_harmonics_N = 20;
design_flags.taylor_number_of_taylor_series_terms_M = 30;

% Modified expansion parameters
design_flags.modified_number_of_harmonics_N = 20;
design_flags.modified_number_of_taylor_series_terms_M = 30;

if attempt_to_estimate_large_gains

    % Number of terms in expansions
    design_flags.number_of_harmonics_N = 10;
    design_flags.number_of_taylor_terms_L = 150;
    design_flags.number_of_exponential_terms_M = 2;

    % Harmonic numbers to analyze for inverse ID
    design_flags.harmonic_numbers_to_analyze = [1 3 5];
    
end

if attempt_to_estimate_small_gains

    % Number of terms in expansions
    design_flags.number_of_harmonics_N = 20;
    design_flags.number_of_taylor_terms_L = 150;
    design_flags.number_of_exponential_terms_M = 6;

    % Harmonic numbers to analyze for inverse ID
    design_flags.harmonic_numbers_to_analyze = [1 3 5];
    
end

if compromise

    % Number of terms in expansions
    design_flags.number_of_harmonics_N = 10;
    design_flags.number_of_taylor_terms_L = 150;
    design_flags.number_of_exponential_terms_M = 2;

    % Harmonic numbers to analyze for inverse ID
    design_flags.harmonic_numbers_to_analyze = [1 3 5];
    
end

end

