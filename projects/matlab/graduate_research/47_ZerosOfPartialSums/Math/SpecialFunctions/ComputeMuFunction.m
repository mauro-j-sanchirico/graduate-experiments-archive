function mu = ComputeMuFunction(j_index, a, xi)

sum = 0;

for k_index = 1:(j_index+1)
    triangle_number_factor = ...
        factorial(j_index)/factorial(j_index-k_index+1);
    polylog_factor = polylog(k_index, -xi) - polylog(k_index, xi);
    a_power = a^(-k_index);
    xi_power = xi.^(j_index-k_index+1);
    
    term = triangle_number_factor ...
        .* polylog_factor ...
        .* a_power ...
        .* xi_power;
    
    sum = sum + term;
    
end

mu = real(sum);

end
