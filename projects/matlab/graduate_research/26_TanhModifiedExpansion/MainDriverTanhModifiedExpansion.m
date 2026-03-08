clear; close all;

set(0, 'defaultTextInterpreter', 'latex');

% Expansion parameters
num_partial_sum_terms_ns = 30;
epsilon = 0.001;

rho = TanhModifiedExpansionComputeRho(num_partial_sum_terms_ns);

% Input to hyperbolic tangent
v = linspace(-4,4,100);
max_v = 4;

[a_coefs, integrals] = TanhModifiedExpansionComputeAllACoefs( ...
    max_v, epsilon, num_partial_sum_terms_ns);

a_coefs

integrals

tanh_v_true = tanh(v);
tanh_v_modified = TanhModifiedExpansionEvaluate(a_coefs, v);

figure;
semilogy(v(v>0), tanh_v_true(v>0), 'color', 'b', 'linewidth', 6);
hold on;
semilogy(v(v>0), tanh_v_modified(v>0), 'color', 'g', 'linewidth', 2);
title('Comparision of True Hyperbolic Tangent and Modified Expansion');
legend('True', 'Modified');
ylabel('tanh(v)');
xlabel('v');
grid on;
grid minor;

figure;
plot(v, tanh_v_true, 'color', 'b', 'linewidth', 6);
hold on;
plot(v, tanh_v_modified, 'color', 'g', 'linewidth', 2);
title('Comparision of True Hyperbolic Tangent and Modified Expansion');
legend('True', 'Modified')
ylabel('$$tanh(v)$$');
xlabel('$$v$$');
grid on;
grid minor;

figure;
stem(log10(abs(a_coefs)));
title('Modified Expansion Coefficients');
ylabel('$$log10(|\alpha|)$$');
grid on;
grid on;

figure;
stem(a_coefs);
ylabel('$$\alpha$$');
title('Modified Expansion Coefficients');
grid on;
grid minor;

mae = sum(abs(tanh_v_true - tanh_v_modified))/length(v)
