function base_freq_hz = GetCombFilterBaseFrequency()
analysis_params = GetAnalysisParams();
freqs_hz = analysis_params.frequency_matrix(:)/(2*pi);
base_freq_hz = double(gcd(sym(freqs_hz)));
end

