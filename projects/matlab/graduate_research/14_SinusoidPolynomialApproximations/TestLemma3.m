function TestLemma3()

omega = 1;
phi = pi/4;
A = 1;
t = 0:0.01:2*pi/omega;

% truth
x_true = A.*sin(omega.*t + phi);

% approx
K = 20;
outer_sum = 0;

for j_prime = 0:K
    
    inner_sum = 0;
    
    for k = j_prime:K
        
        % even part
        j = 2*j_prime;
        quotient = (-1)^k/factorial(2*k+1);
        binomial_coef = nchoosek(2*k+1, j);
        term = quotient*binomial_coef*phi^(2*k+1-j)*omega^j.*t.^j;
        inner_sum = inner_sum + term;
        
        % odd part
        j = 2*j_prime+1;
        quotient = (-1)^k/factorial(2*k+1);
        binomial_coef = nchoosek(2*k+1, j);
        term = quotient*binomial_coef*phi^(2*k+1-j)*omega^j.*t.^j;
        inner_sum = inner_sum + term;

    end
    
    outer_sum = outer_sum + inner_sum;
end

x_approx = A.*outer_sum;

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
