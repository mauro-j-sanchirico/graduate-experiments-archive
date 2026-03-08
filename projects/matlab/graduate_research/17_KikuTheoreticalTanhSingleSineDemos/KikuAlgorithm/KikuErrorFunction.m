function [error] = KikuErrorFunction(gamma, kappa_matrix, beta_0, beta)
design_flags = GetDesignFlags();
gamma_powers = gamma.^(0:design_flags.number_of_taylor_terms_L)';
epsilon = kappa_matrix*gamma_powers + beta_0 - beta;
selected_epsilons = epsilon(design_flags.harmonic_numbers_to_analyze);
error = sum(selected_epsilons.^2)/length(selected_epsilons);
end

