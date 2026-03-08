%% RunKappaTheoremTest
%
% @brief Runs a test of the Kappa theorem
%
% @details The Kappa theorem (derived in MJS notes 3/11/19 and 3/17/2019)
% allows expression the fourier series of tanh(gamma*sin(x)) in terms of
% a set of Kappa coefficients attached to powers of the gain gamma.
%
% @returns void
%

function RunKappaTheoremTest(n_max, L_max, gamma_gain)

fprintf('Testing Kappa Theorem for gamma = %f...\n', gamma_gain);

% Test parameters

% dx is used for numerical computational checks
dx = 0.0001;

% Load the kappa coefs
load('tables/kappa_table.mat', 'kappa_table');

% Compute some fourier coefficients
b_numerical = zeros(1, n_max+1);
b_theoretical = zeros(1, n_max+1);

for n = 0:n_max
    b_numerical(n+1) = ComputeFourierCoefNumerical(n, gamma_gain, dx);
    b_theoretical(n+1) = ...
        ComputeFourierCoefTheoretical(n, gamma_gain, L_max, kappa_table);
end

b_numerical
b_theoretical

x = 0:0.000001:pi;
y_theoretical = zeros(size(x));
y_numerical = zeros(size(x));

for n = 0:n_max
    y_theoretical = ...
        y_theoretical + 2/pi*b_theoretical(n+1)*sin((2*n-1)*x);
    y_numerical = y_numerical + 2/pi*b_numerical(n+1)*sin((2*n-1)*x);
end

% Plot the theoretical expansion and numerical functions
figure;
plot(x, y_theoretical);
hold on;
plot(x, y_numerical);
grid on;
grid minor;
xlabel('x');
ylabel('y');
title_str = sprintf('Function approximation for \\gamma = %d', gamma_gain);
title(title_str);
legend('theorem', 'truth');

% Compute Beta vector as per the Kappa Theorem
beta_0 = 2./(2*(0:n_max) - 1);
beta_vector = b_numerical' - beta_0';

% Compute a vector with the powers of gamma
gamma_powers = [gamma_gain.^(0:L_max)]';

% Get the Kappa matrix, which is a subset of the Kappa table
kappa_matrix = kappa_table(1:n_max+1,1:L_max+1);

% Adjust the first column of the kappa matrix
kappa_matrix(:,1) = kappa_matrix(:,1) - beta_vector;

% Flip the kappa matrix so we can use its rows as the coefficients of a
% polynomial
kappa_matrix = fliplr(kappa_matrix);

gamma_sweep = 0:0.0001:pi;
p1 = polyval(kappa_matrix(1,:), gamma_sweep);
p2 = polyval(kappa_matrix(2,:), gamma_sweep);
p3 = polyval(kappa_matrix(3,:), gamma_sweep);
p4 = polyval(kappa_matrix(4,:), gamma_sweep);
p5 = polyval(kappa_matrix(5,:), gamma_sweep);

figure;
plot(gamma_sweep, p1);
hold on
plot(gamma_sweep, p2);
plot(gamma_sweep, p3);
plot(gamma_sweep, p4);
plot(gamma_sweep, p5);
grid on;
grid minor;
xlabel('\gamma');
ylabel('K Polynomials');
title_str = sprintf('Kappa Polynomials for \\gamma = %.2f', gamma_gain);
title(title_str);
legend('P_1(\gamma)', ...
       'P_2(\gamma)', ...
       'P_3(\gamma)', ...
       'P_4(\gamma)', ...
       'P_5(\gamma)');

fprintf('done.\n');
end

