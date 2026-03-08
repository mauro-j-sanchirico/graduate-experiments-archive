function experiment_params = GetExperimentParams()

% The number of networks we will be testing for the validation experiment
experiment_params.num_networks_under_test = 100;

% The number of networks we will be testing for the ROC curve experiment
experiment_params.num_networks_under_test_roc = 300;

% The number of networks we will be testing for the entropy experiment
experiment_params.num_networks_under_test_entropy = 100;

experiment_params.debug_plots = false;

end

