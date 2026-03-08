function y = cshi(j_index, xi)

a = pi/2;
sum = 0;

for k_index = 1:(j_index + 1)
    
    exp_arg = exp(a*xi);
    
    triangle_number_factor = ...
        factorial(j_index) / factorial(j_index - k_index + 1);
    
    polylog_factor = ...
        polylog(k_index, -exp_arg) - polylog(k_index, exp_arg);
    
    a_power = a^(-k_index);
    xi_power = xi.^(j_index - k_index + 1);
    
    term = triangle_number_factor ...
        * (-1)^(k_index-1) ...
        * polylog_factor ...
        * a_power ...
        .* xi_power;
    
    sum = sum + term;
    
end

y = real(sum);

end
