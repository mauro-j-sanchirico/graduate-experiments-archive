function AnalyzeApproxTanhError(n_max, alpha)

n = 1:n_max;
t = 0:0.1:2*pi;
x = sin(t);
len = length(x);
mse_y = zeros(length(n), length(alpha));
legend_strs = cell(size(alpha));

for alpha_idx = 1:length(alpha)
    for n_idx = 1:length(n)
        y_approx = ApproxTanh(alpha(alpha_idx)*x, n(n_idx));
        y = tanh(alpha(alpha_idx)*x);
        mse_y(n_idx, alpha_idx) = mse(y, y_approx);
    end
    legend_strs{alpha_idx} = sprintf('\\alpha=%0.2f', alpha(alpha_idx));
end

figure;
semilogy(n, mse_y, 'linewidth', 2);
grid on;
grid minor;
xlabel('Number of Terms in Approx.');
ylabel('log_{10}(MSE)');
title('MSE(y_a, y); y_a ~ tanh({\alpha}sin(x)); y = tanh(\alpha sin(x))');
legend(legend_strs);
end