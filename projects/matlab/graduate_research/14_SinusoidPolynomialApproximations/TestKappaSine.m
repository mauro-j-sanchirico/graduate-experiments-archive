function TestKappaSine

% Sinusoid parameters
A = [1 2];
omega = [1 3];
phi = [pi/5 pi/4];
bias = 1;
t = 0:0.01:2*pi/omega(1);

% Approximation parameters
K = 25;

% Get truth to test against
x_true = EvaluateMultisine(A, omega, phi, bias, t);

% Build the Kappa approximation
[kappa_sine_even_matrix, kappa_sine_odd_matrix] = ...
   BuildKappaMultisine(A, omega, phi, bias, K);

% Evaluate the Kappa approximation
x_approx = EvaluateKappaMultisine( ...
    kappa_sine_even_matrix, kappa_sine_odd_matrix, t, K);

figure;
plot(t, x_true, 'b', 'linewidth', 6);
hold on;
plot(t, x_approx, 'g', 'linewidth', 2);
xlabel('t (s)');
ylabel('x(t)');
legend('true', 'approx.');
grid on;
grid minor;

end
