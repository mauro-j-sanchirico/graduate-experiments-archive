function VisualizeOutputSpectrum(t, y_measured)

% Get signal info (sample rate, length)
dt = t(2) - t(1);
fs = 1/dt;
signal_length = length(t);

% Compute fft
y_fft = fft(y_measured);

% Compute one sided spectrum
p2 = abs(y_fft/signal_length);
p1 = p2(1:signal_length/2+1);
p1(2:end-1) = 2*p1(2:end-1);

% Plot the spectrum
fig_handle = figure;
f = fs*(0:(signal_length/2))/signal_length;
plot(f, p1, 'k')
grid on;
grid minor;
title('Measured Amplitude Spectrum of $$y(t)$$');
xlabel('$$f \mathrm{(Hz)}$$');
ylabel('$$|\mathrm{FFT}\{y(t)\}|$$');
saveas(fig_handle, './Images/MeasuredNetworkOutputSpectrum.png');

end
