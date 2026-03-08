clc; clear; close all;

v_values = -1:0.1:1;
xi = 0.01:0.01:100;
max_taylor_sum_terms_m = 10;

lhs = tanh(v_values);

rhs_step_1 = zeros(size(v_values));
rhs_step_2 = zeros(size(v_values));
rhs_step_3 = zeros(size(v_values));
rhs_step_4 = zeros(size(v_values));
rhs_step_5 = zeros(size(v_values));

% Check step 1
for idx = 1:length(v_values)
    
    v = v_values(idx);
    integrand = csch((pi/2)*xi).*sin(xi.*v);
    integral = trapz(xi, integrand);
    rhs_step_1(idx) = integral;

end

% Check step 2
for idx = 1:length(v_values)

    v = v_values(idx);
    sum = zeros(size(xi));
    
    for m = 1:max_taylor_sum_terms_m
        
        numerator = (-1)^(m-1)*xi.^(2*m-1)*v^(2*m-1);
        denominator = factorial(2*m-1);
        term = numerator / denominator;
        sum = sum + term;
        
    end
    
    integrand = csch((pi/2)*xi).*sum;
    integral = trapz(xi, integrand);
    rhs_step_2(idx) = integral;

end

% Check step 3
for idx = 1:length(v_values)

    v = v_values(idx);
    sum = 0;
    
    for m = 1:max_taylor_sum_terms_m
        
        integrand = xi.^(2*m-1).*csch((pi/2)*xi);
        integral = trapz(xi, integrand);
        
        numerator = (-1)^(m-1)*v^(2*m-1);
        denominator = factorial(2*m-1);
        term = integral*numerator/denominator;
        
        sum = sum + term;
        
    end
    
    rhs_step_3(idx) = sum;

end

% Check step 4
for idx = 1:length(v_values)

    v = v_values(idx);
    sum = 0;
    
    for m = 1:max_taylor_sum_terms_m
        
        numerator = ...
            abs(bernoulli(2*m))*(2^(2*m) - 1) ...
           *2^(2*m)*(-1)^(m-1)*v^(2*m-1);
        denominator = 2*m*factorial(2*m-1);
        term = numerator / denominator;
        sum = sum + term;
        
    end
    
    rhs_step_4(idx) = sum;

end

% Check step 5 simplifications
m = 4;

lhs_step_5_identity_1 = 2*m*(factorial(2*m - 1));
rhs_step_5_identity_1 = gamma(2*m + 1);

lhs_step_5_identity_2 = gamma(2*m + 1);
rhs_step_5_identity_2 = factorial(2*m);

lhs_step_5_identity_3 = (-1)^(m-1)*abs(bernoulli(2*m));
rhs_step_5_identity_3 = bernoulli(2*m);

error_step_5_identity_1 = lhs_step_5_identity_1 - rhs_step_5_identity_1
error_step_5_identity_2 = lhs_step_5_identity_2 - rhs_step_5_identity_2
error_step_5_identity_3 = lhs_step_5_identity_3 - rhs_step_5_identity_3

% Check step 5
for idx = 1:length(v_values)

    v = v_values(idx);
    sum = 0;
    
    for m = 1:max_taylor_sum_terms_m
        
        numerator = (2^(2*m) - 1)*2^(2*m)*bernoulli(2*m)*v^(2*m-1);
        denominator = factorial(2*m);
        term = numerator / denominator;
        sum = sum + term;
        
    end
    
    rhs_step_5(idx) = sum;

end

error_1 = abs(lhs - rhs_step_1);
error_2 = abs(lhs - rhs_step_2);
error_3 = abs(lhs - rhs_step_3);
error_4 = abs(lhs - rhs_step_4);
error_5 = abs(lhs - rhs_step_5);

figure;
plot(v_values, lhs);
hold on;
plot(v_values, rhs_step_1);
plot(v_values, rhs_step_2);
plot(v_values, rhs_step_3);
plot(v_values, rhs_step_4);
plot(v_values, rhs_step_5);

figure;
semilogy(v_values, error_1);
hold on;
semilogy(v_values, error_2);
semilogy(v_values, error_3);
semilogy(v_values, error_4);
semilogy(v_values, error_5);
