function x_stim = GetSweepStimuli()

mlp_hyperparams = GetMLPHyperparams();
analysis_params = GetAnalysisParams();

x_sweep = linspace( ...
    -analysis_params.max_feature_value, ...
     analysis_params.max_feature_value, ...
     analysis_params.n_interrogation_points);
 
x_stim = repmat(x_sweep, [mlp_hyperparams.num_input 1]);

end

