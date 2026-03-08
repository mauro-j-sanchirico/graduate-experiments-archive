function PlotPartialSumComparison( ...
    f_true, f_partial_sum, big_n, r, ...
    xlabel_str, title_str)

dx = 0.01;
x = -r:dx:r;

y_true = f_true(x);
y_partial_sum = f_partial_sum(big_n, x);
remainder = y_true - y_partial_sum;

figure('Renderer', 'painters', 'Position', [10 60 800 600]);
subplot(211)
plot(x, y_true, 'k-');
hold on;
plot(x, y_partial_sum, 'k--');
grid on;
grid minor;
xlabel(xlabel_str);
title(title_str);

subplot(212)
plot(x, remainder, 'k-');
grid on;
grid minor;
xlabel(xlabel_str);
title('Remainder');


end
