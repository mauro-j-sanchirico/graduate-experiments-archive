function design_flags = GetDesignFlags()

% New table generation
design_flags.new_mu_table = false;
design_flags.new_q_table = false;
design_flags.new_kappa_table = true;

% Plot options
design_flags.error_plots = true;
design_flags.hidden_parameter_plots = true;

% Configurations
attempt_to_estimate_large_gains = false;
attempt_to_estimate_small_gains = false;
compromise = true;
medium_gains = false;

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
    design_flags.number_of_harmonics_N = 1;
    design_flags.number_of_taylor_terms_L = 150;
    design_flags.number_of_exponential_terms_M = 9;

    % Harmonic numbers to analyze for inverse ID
    design_flags.harmonic_numbers_to_analyze = [1];
    
end

if compromise

    % Number of terms in expansions
    design_flags.number_of_harmonics_N = 1;
    design_flags.number_of_taylor_terms_L = 150;
    design_flags.number_of_exponential_terms_M = 2;

    % Harmonic numbers to analyze for inverse ID
    design_flags.harmonic_numbers_to_analyze = [1];
    
end

if medium_gains

    % Number of terms in expansions
    design_flags.number_of_harmonics_N = 1;
    design_flags.number_of_taylor_terms_L = 150;
    design_flags.number_of_exponential_terms_M = 4;

    % Harmonic numbers to analyze for inverse ID
    design_flags.harmonic_numbers_to_analyze = [1];
    
end


end

