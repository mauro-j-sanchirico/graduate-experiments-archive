%% Testingrf the Analytical Mu Function Algorithm
%% Setup

clc; clear; close all;


%% Sweep the "n" and "l" parameters and compare analytic vs. numerical

n_max = 5;
l_max = 50;

n = 0:n_max;
l = 0:l_max;

for n_idx = 1:length(n)
    figure;
    
    title_str = sprintf('\\mu(l,%i)', n(n_idx));
    
    mu_analytical = zeros(1,length(l));
    mu_numerical = zeros(1,length(l));
    
    for l_idx = 1:length(l)
        mu_analytical(l_idx) = ComputeMuFunction(n(n_idx), l(l_idx));
        mu_numerical(l_idx) = ComputeMuFunctionNumerical(n(n_idx), l(l_idx));
    end
    
    plot(l, mu_analytical, 'kx', 'MarkerSize', 10);
    hold on;
    plot(l, mu_numerical, 'ko', 'MarkerSize', 10);
    grid on;
    legend('analytical', 'numerical');
    title(title_str);
    xlabel('l (integer)');
    ylabel('\mu')
end
