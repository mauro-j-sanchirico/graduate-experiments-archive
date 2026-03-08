%% Main Driver Program for Theoretical Kiku Algorithm
%% Variant for a Single Sine with Arbitrary Gain
%
% @author Mauro J. Sanchirico III
%

clc; clear; close all;

%% Load Design Flags

design_flags = GetDesignFlags();

%% Analyze the Mu Function

load('tables/mu_table.mat', 'mu_table');

if design_flags.mu_function_3d_analysis == true
    AnalyzeMuFunction3D(mu_table);
end

if design_flags.mu_function_2d_analysis == true
    AnalyzeMuFunction2D(mu_table);
end


%% Analyze the Q Function

load('tables/q_table.mat', 'q_table');

if design_flags.q_function_3d_analysis == true
    AnalyzeQFunction3D(q_table);
end

if design_flags.q_function_2d_analysis == true
    AnalyzeQFunction2D(q_table);
end


%% Analyze the Kappa Function

load('tables/kappa_table.mat', 'kappa_table');

if design_flags.kappa_function_3d_analysis == true
    AnalyzeKappaFunction3D(kappa_table);
end

if design_flags.kappa_function_2d_analysis == true
    AnalyzeKappaFunction2D(kappa_table);
end


%% Test the Kappa Theorem

if design_flags.test_kappa_theorem == true
    
    gamma_gain = 3;
    RunKappaTheoremTest( ...
        design_flags.n_max, design_flags.L_max, gamma_gain);
    
    gamma_gain = 2;
    RunKappaTheoremTest( ...
        design_flags.n_max, design_flags.L_max, gamma_gain);
    
    gamma_gain = 1.5;
    RunKappaTheoremTest( ...
        design_flags.n_max, design_flags.L_max, gamma_gain);
    
    gamma_gain = 1.0;
    RunKappaTheoremTest( ...
        design_flags.n_max, design_flags.L_max, gamma_gain);
    
    gamma_gain = 0.5;
    RunKappaTheoremTest( ...
        design_flags.n_max, design_flags.L_max, gamma_gain);
    
    gamma_gain = 0.2;
    RunKappaTheoremTest( ...
        design_flags.n_max, design_flags.L_max, gamma_gain);
end

