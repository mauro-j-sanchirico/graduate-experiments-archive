function [a_coef, integral] = TanhModifiedExpansionComputeACoef( ...
    m, max_v, epsilon, num_partial_sum_terms_ns)

m2_minus_1 = 2*m - 1;
sign_term = (-1).^(m-1);
factorial_term = 1./factorial(vpa(m2_minus_1));
a = pi/2;

rho = TanhModifiedExpansionComputeRho(num_partial_sum_terms_ns);

safety_multiplier = 1.5;

rho_v = rho/(safety_multiplier*max_v);

% Analytic option
big_eta_antiderivative_epsilon = ...
    TanhModifiedExpansionComputeEtaAntiderivative(m2_minus_1, a, epsilon);

big_eta_antiderivative_rho = ...
    TanhModifiedExpansionComputeEtaAntiderivative(m2_minus_1, a, rho_v);

integral = big_eta_antiderivative_rho - big_eta_antiderivative_epsilon;

% Numerical option
dx = epsilon;
x = dx:dx:rho_v;
a = pi/2;
integrand = csch(a*x).*x.^m2_minus_1;
integral = trapz(x, integrand);

a_coef = sign_term.*factorial_term.*integral;

end
