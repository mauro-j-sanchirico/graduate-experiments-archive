clc; clear; close all;

M = 25;
xi = 0.01:0.01:10;

v_values = -2:0.01:2;

lhs_integral = zeros(size(v_values));
rhs_integral = zeros(size(v_values));

fourier_sin_transform_xi = csch((pi/2)*xi);

for idx = 1:length(v_values)

    v = v_values(idx);
    lhs_integrand = fourier_sin_transform_xi.*sin(xi*v);
    lhs_integral(idx) = trapz(xi, lhs_integrand);
    
    sum = zeros(size(xi));
    
    % Taylor series of sin(xi*v)
    for m = 1:M
        coef = ((-1)^(m-1))/factorial(2*m-1);
        term = coef*((xi*v).^(2*m-1));
        sum = sum + term;
    end
    
    rhs_integrand = fourier_sin_transform_xi.*sum;
    rhs_integral(idx) = trapz(xi, rhs_integrand);
    
end

figure
plot(v_values, lhs_integral)
hold on
plot(v_values, rhs_integral)

error = abs(lhs_integral - rhs_integral);

figure
plot(v_values, error);


