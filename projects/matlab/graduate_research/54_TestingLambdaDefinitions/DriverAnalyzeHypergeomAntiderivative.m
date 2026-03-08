clc; clear; close all;

set(groot, 'defaulttextInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter', 'latex');
set(groot, 'DefaultLineLineWidth', 2);
set(groot, 'defaultAxesFontSize', 12);

% Analyze the function
dzeta = 0.2;
zeta = 0.1:dzeta:8;
a = pi/2;

figure;

for j = 1:2:5

    fprintf('Analyzing Function for j = %d...\n', j);
    lambda = ComputeHypergeomAntiderivative(j, a, zeta);
    
    plot(zeta, lambda);
    hold on;
    
end

grid on;
xlabel('$$\zeta$$');
ylabel('$$\Lambda(\zeta)$$');

