function  y = ApplyCombFilter(base_freq_hz, t, x, n_harmonics, tolerance)

y = zeros(size(x));
dt = t(2) - t(1);
fs = 1/dt;

for n = 1:n_harmonics
    
    freq_hz = n*base_freq_hz;
    w_start = (1 - tolerance)*freq_hz;
    w_stop = (1 + tolerance)*freq_hz;
    w_pass = [w_start w_stop];
    
    filter_output = bandpass(x, w_pass, fs);
    
    y = y + filter_output(1:length(t));

end

% Add back dc bias
y = y + mean(x);
