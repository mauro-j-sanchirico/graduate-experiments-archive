%% CollectResponse
%
% @breif Collects the response of an MLP to a stimulus with measurement
% noise
%
% @param[in] mlp_params - The parameter struct of the MLP
%
% @param[in] x_stimulus - The stimulus matrix for the neural net.  Each
% row cooresponds to the one input of the MLP and each column cooresponds
% to one sample
%
% @returns y_response - The response vector for the neural network where
% each element cooresponds to the output at one sampled time.
%

function y_response = CollectResponse(mlp_params, x_stimulus)

analysis_params = GetAnalysisParams();
y_response = EvalMLP(mlp_params, x_stimulus);
y_response = awgn(y_response, analysis_params.measurement_snr);

end
