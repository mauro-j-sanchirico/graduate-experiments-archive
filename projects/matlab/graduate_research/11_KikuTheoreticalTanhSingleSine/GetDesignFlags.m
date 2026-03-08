%% GetDesignFlags
%
% @breif Returns a data structure containing design flags
%
% @details Design flags may be set in order to run the main program in
% different modes or explore different algorithm design options.
%
function design_flags = GetDesignFlags()

% ------------------------------------------------------------------------
% Algorithm Parameters
% ------------------------------------------------------------------------
design_flags.n_max = 5;
design_flags.L_max = 400;

% ------------------------------------------------------------------------
% Theorem Testing
% ------------------------------------------------------------------------
design_flags.test_kappa_theorem = true;

% ------------------------------------------------------------------------
% Analysis
% ------------------------------------------------------------------------
design_flags.mu_function_3d_analysis = true;
design_flags.mu_function_2d_analysis = true;

design_flags.q_function_3d_analysis = true;
design_flags.q_function_2d_analysis = true;

design_flags.kappa_function_3d_analysis = true;
design_flags.kappa_function_2d_analysis = true;

end

