function y_response = CollectResponse(mlp_params, x_stimulus)

analysis_params = GetAnalysisParams();
y_response = EvalMLP(mlp_params, x_stimulus);
y_response = awgn(y_response, analysis_params.measurement_snr);

end
