%% New Approximation to the Hyperbolic Tangent
%% Error Analysis

clc; clear; close all;

compute_new_epsilon_curve = true;


%% Define a range of inputs
%
% This is the range in which we can compute the tanh to machine precision.
% Outside this range tanh(x) = sign(x)
%

x = -pi/2:0.0001:pi/2;


%% Compute best MSE wrt M and Best Epsilon wrt M

M_list = [1 5 10 20 50 70 100 150 200];
powers = 1:-0.1:-10;
epsilon_list = 10.^powers;

best_epsilon_list = zeros(size(M_list));
best_mse_list = zeros(size(M_list));

if compute_new_epsilon_curve

    figure;

    for i = 1:length(M_list)

        mse_list = zeros(size(epsilon_list));

        for j = 1:length(epsilon_list)

            y_true = tanh(x);
            y_approx = ...
                ComputeTanhExponentialSeries(x, M_list(i), epsilon_list(j));

            error = abs(y_true - y_approx);
            mse_list(j) = mean(error.^2);

        end

        [best_mse, best_idx] = min(mse_list);
        best_epsilon_list(i) = epsilon_list(best_idx);
        best_mse_list(i) = best_mse;

        loglog(epsilon_list, mse_list);
        hold on;

    end
    
    save best_epsilon_list
    
else
    
    load best_epsilon_list
    
end

xlabel('\epsilon');
ylabel('MSE');
title('MSE in Approx. tanh(x) vs. truth wrt \epsilon');
grid on;
grid minor;

figure;
loglog(M_list, best_epsilon_list, 'k', 'linewidth', 2);
hold on;
loglog(M_list, 1./(2*M_list.^0.5), '--k');
xlabel('M');
ylabel('best \epsilon');
title('Best \epsilon for a given M');
grid on;
grid minor;
legend('\epsilon_{min MSE}', '1/(2*sqrt(M))');

figure;
loglog(M_list, best_mse_list, 'k', 'linewidth', 2);
xlabel('M');
ylabel('best MSE');
title('Best MSE for a given M');
grid on;
grid minor;

