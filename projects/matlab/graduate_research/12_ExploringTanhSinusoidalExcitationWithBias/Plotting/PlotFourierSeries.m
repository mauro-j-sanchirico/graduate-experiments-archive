function PlotFourierSeries(a, b, n)

c = sqrt(a.^2 + b.^2);

figure('Renderer', 'painters', 'Position', [10 10 700 400]);

bar(n, c);
xticks(n);
xlabel('Harmonic (n)');
title('Fourier Magnitudes');
grid on;
grid minor;

figure('Renderer', 'painters', 'Position', [10 10 700 400]);

subplot(211)
bar(n, a);
xlabel('Harmonic (n)');
xticks(n);
title('Cosine Series Coefficients (a)');
grid on;
grid minor;

subplot(212)
bar(n, b);
xlabel('Harmonic (n)');
xticks(n);
title('Sign Series Coefficients (b)');
grid on;
grid minor;

end
