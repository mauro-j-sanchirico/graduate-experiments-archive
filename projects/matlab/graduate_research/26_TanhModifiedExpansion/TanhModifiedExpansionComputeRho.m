function rho = ...
    TanhModifiedExpansionComputeRho(num_partial_sum_terms_ns)

tau = 1;

% Analytical, error
%ns_plus_1 = num_partial_sum_terms_ns + 1;
%rho = (tau*factorial(ns_plus_1)).^(1/ns_plus_1);

% Heuristic - works better than analytical, because it is tied to the last
% zero of the partial sum, so the integral always ends at the zero of the
% sinusoid
q1 = 0.8129;
q0 = 1.3991;
rho = q1*num_partial_sum_terms_ns + q0;

% Analytical - works
q = 2*num_partial_sum_terms_ns + 3;
rho = factorial(q).^(1/q); 

end
