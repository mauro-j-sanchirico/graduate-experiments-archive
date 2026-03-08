clc; clear; close all;

xi = 0.01:0.01:10;
a = pi/2;
max_j = 4;
j_list = 1:max_j;
antiderivatives_eta = zeros(max_j, length(xi));

for idx = 1:length(j_list)
    
    j = j_list(idx);
    
    antiderivatives_eta(idx,:) = ...
        ComputeGeneralEtaAntiderivative(xi, a, j);
    
end

figure;
semilogy(xi, abs(real(antiderivatives_eta)), 'b');
hold on;
semilogy(xi, abs(imag(antiderivatives_eta)), 'r');

function antiderivative_eta = ComputeGeneralEtaAntiderivative(xi, a, j)

sum = zeros(size(xi));

for k = 1:(j+1)
    
    sign_factor = (-1)^(k-1);
    triangle_factor = factorial(j)/factorial(j-k+1);
    exponential = exp(a.*xi);
    delta_polylog_factor = ...
        polylog(k, -exponential) - polylog(k, exponential);
    a_factor = a^(-k);
    xi_factor = xi.^(j-k+1);
    
    term = ...
        sign_factor*triangle_factor ...
       *a_factor*delta_polylog_factor.*xi_factor;
    
    sum = sum + term;
    
end

antiderivative_eta = sum;

end