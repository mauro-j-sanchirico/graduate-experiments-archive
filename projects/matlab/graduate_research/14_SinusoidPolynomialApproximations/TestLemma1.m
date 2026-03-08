function TestLemma1()

omega = 1;
phi = 0;
A = 1;
t = 0:0.01:2*pi/omega;

% truth
x_true = A.*sin(omega.*t + phi);

% approx
K = 20;
sum = 0;

for k = 0:K
    term = (-1)^k*(omega*t+phi).^(2*k+1)/factorial(2*k+1);
    sum = sum + term;
end

x_approx = A.*sum;

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

