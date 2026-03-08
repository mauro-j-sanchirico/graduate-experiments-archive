function [x] = EvaluateKappaMultisine( ...
    kappa_sine_even_matrix, kappa_sine_odd_matrix, t, K)

% build the tau matricies
tau_even_matrix = BuildTauEvenMatrix(K, t);
tau_odd_matrix = BuildTauOddMatrix(K, t);

% Apply Lemma 4
even_part = tau_even_matrix*kappa_sine_even_matrix;
odd_part = tau_odd_matrix*kappa_sine_odd_matrix;

x = odd_part + even_part;

end

