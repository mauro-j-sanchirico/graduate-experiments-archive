function [kappa_sine_even_matrix, kappa_sine_odd_matrix] = ...
   BuildKappaSine(A, omega, phi, K)

% build the even and odd mu tables for the sinusoid
mu_sine_even_matrix = BuildMuSineEvenMatrix(K);
mu_sine_odd_matrix = BuildMuSineOddMatrix(K);

% build the even and odd Phi tables for the sinusoid
phi_sine_even_matrix = BuildPhiSineEvenMatrix(K, phi);
phi_sine_odd_matrix = BuildPhiSineOddMatrix(K, phi);

% build the even and odd omega vectors
omega_sine_even_matrix = BuildOmegaSineEvenMatrix(K, omega);
omega_sine_odd_matrix = BuildOmegaSineOddMatrix(K, omega);

% build the kappa vectors accorting to Lemma 4
hadamard_even = mu_sine_even_matrix.*phi_sine_even_matrix;
hadamard_odd = mu_sine_odd_matrix.*phi_sine_odd_matrix;

% A more efficient way of computing diag(x*y) is to use sum(x.*y', 2)
kappa_sine_even_matrix = A*sum(hadamard_even.*omega_sine_even_matrix', 2);
kappa_sine_odd_matrix = A*sum(hadamard_odd.*omega_sine_odd_matrix', 2);

end

