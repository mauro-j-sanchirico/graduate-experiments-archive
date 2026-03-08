clc; clear; close all;

num_partial_sum_terms_n_s = 10;
m_list = 1:num_partial_sum_terms_n_s;
q1 = 0.8129;
q0 = 1.3991;
rho = q1*num_partial_sum_terms_n_s + q0;
a = pi/2;

integral_lhs_numerical = zeros(size(m_list));
integral_rhs_analytical = zeros(size(m_list));

for idx = 1:length(m_list)

    fprintf('Computing integral %i/%i\n', idx, length(m_list));
    m = m_list(idx);
    j = 2*m-1;
    
    integral_rhs_analytical(idx) = ComputeIntegralAnalytically(rho, a, j);
    integral_lhs_numerical(idx) = ComputeIntegralNumerically(rho, a, j);

end

figure;
semilogy(m_list, integral_lhs_numerical, 'x');
hold on
semilogy(m_list, integral_rhs_analytical, 'o');

function integral = ComputeIntegralAnalytically(rho, a, j)

epsilon = 0.000001;

big_eta_rho = ComputeEtaAntiderivative(rho, a, j);
big_eta_eps = ComputeEtaAntiderivative(epsilon, a, j);

integral = big_eta_rho - big_eta_eps;

end

function big_eta = ComputeEtaAntiderivative(xi, a, j)

sum = 0;

for k = 1:(j+1)
    
    sign_factor = (-1)^(k-1);
    triangle_number = factorial(j)/factorial(j-k+1);
    exponential = exp(a*xi);
    polylog_delta = polylog(k, -exponential) - polylog(k, exponential);
    a_factor = a^(-k);
    xi_factor = xi.^(j-k+1);
    
    term = sign_factor*triangle_number*polylog_delta*a_factor*xi_factor;
    sum = sum + term;
    
end

big_eta = real(sum);

end

function integral = ComputeIntegralNumerically(rho, a, j)

xi = 0.001:0.001:rho;
integrand = xi.^j.*csch(a*xi);
integral = trapz(xi, integrand);

end