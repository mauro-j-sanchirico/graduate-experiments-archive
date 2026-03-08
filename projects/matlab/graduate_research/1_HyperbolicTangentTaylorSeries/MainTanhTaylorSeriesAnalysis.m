%% Analysis of the Taylor Series for Tanh
%% Setup

clc; clear; close all;


%% Approximation of tanh(x)
%
% Here we plot an approximation of tanh(x) with a varying number of terms.
% The function ApproxTanh uses an n-term Taylor series expansion of tanh
% about the point x=0.  We see how the series approximation diverges for
% |x| > pi/2.  Because of this divergence, adding more terms to the series
% makes the approximation worse for large x.
%

x = -pi/2:0.01:pi/2;
y = tanh(x);
n = 1:7;
y_approx = cell(size(n));
error = cell(size(n));
legend_strs = cell(size(n));

for idx = 1:length(n)
    y_approx{idx} = ApproxTanh(x,n(idx));
    error{idx} = abs(y - y_approx{idx});
end

figure;
plot(x, y, 'k--', 'linewidth', 2);
hold on

for idx = 1:length(n)
    plot(x, y_approx{idx}, 'linewidth', 2);
    legend_strs{idx} = sprintf('n=%i', idx);
end

grid on;
xlabel('x');
ylabel('y');
title('Approximations of tanh(x)');
legend(legend_strs, 'location', 'southeast');

figure;
hold on;
for idx = 1:length(n)
    plot(x, error{idx}, 'linewidth', 2);
    legend_strs{idx} = sprintf('n=%i', idx);
end

grid on;
xlabel('x');
ylabel('|y-y_a|');
title('Error Functions');
legend(legend_strs, 'location', 'southeast');


%% Approximation of tanh(a*sin(t))
%
% Here we test the validity of a 5 term approximation on sine waves of
% different amplitudes.  We also show how the expansion is not valid for
% |x| > pi/2.
%

n = 10;
alpha = [0.1, 0.5, 1, 1.2, pi/2, pi/2+0.1];
t = 0:0.01:4*pi;
x = sin(t);
y_approx = cell(size(alpha));
y = cell(size(alpha));
error = cell(size(alpha));
legend_strs = cell(size(n));

for idx = 1:length(alpha)
    y_approx{idx} = ApproxTanh(alpha(idx)*x, n);
    y{idx} = tanh(alpha(idx)*x);
    error{idx} = abs(y{idx} - y_approx{idx});
end

figure('Renderer', 'painters', 'Position', [10 10 900 600]);
subplot(311);
hold on;
for idx = 1:length(alpha)
    plot(t, y{idx}, 'linewidth', 2);
    legend_strs{idx} = sprintf('\\alpha=%.2f', alpha(idx));
end
grid on;
xlabel('t');
ylabel('y = tan({\alpha}sin(t)');
title('Truth for tanh({\alpha}sin(x))');
legend(legend_strs, 'location', 'southeast');

subplot(312);
hold on;
for idx = 1:length(alpha)
    plot(t, y_approx{idx}, 'linewidth', 2);
    legend_strs{idx} = sprintf('\\alpha=%.2f', alpha(idx));
end
grid on;
xlabel('t');
ylabel('y_a ~ tan({\alpha}sin(x))');
title('Approximations of tanh({\alpha}sin(x))');
legend(legend_strs, 'location', 'southeast');

subplot(313)
hold on;
for idx = 1:length(alpha)
    plot(t, log10(error{idx}), 'linewidth', 2);
    legend_strs{idx} = sprintf('\\alpha=%0.2f', alpha(idx));
end
grid on;
grid minor;
xlabel('x');
ylabel('log_{10}(|y-y_a|)');
title('Error Functions');
legend(legend_strs, 'location', 'southeast');

%% Mean square error with respect to n. terms for different amplitudes
%
% Here we see for a given amplitude how many terms we need to get down to
% machine precision.  Note for amplitudes greater than pi/2 the
% approximation gets worse with more terms because the series diverges.
%

alpha = [0.1, 0.5, 1, 1.2, pi/2, 1.6 1.7];
n_max = 50;
AnalyzeApproxTanhError(n_max, alpha);

