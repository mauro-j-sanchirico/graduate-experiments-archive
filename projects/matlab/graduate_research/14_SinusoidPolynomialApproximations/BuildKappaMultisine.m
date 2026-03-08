function [kappa_multisine_even_matrix, kappa_multisine_odd_matrix] = ...
   BuildKappaMultisine(A, omega, phi, bias, K)

kappa_multisine_even_matrix = zeros(K+1, 1);
kappa_multisine_odd_matrix = zeros(K+1, 1);

for i = 1:length(A)

    [kappa_sine_even_matrix, kappa_sine_odd_matrix] = ...
         BuildKappaSine(A(i), omega(i), phi(i), K);

    kappa_multisine_even_matrix = ...
        kappa_multisine_even_matrix + kappa_sine_even_matrix;

    kappa_multisine_odd_matrix = ...
        kappa_multisine_odd_matrix + kappa_sine_odd_matrix;

end

kappa_multisine_even_matrix(1) = ...
    kappa_multisine_even_matrix(1) + bias

end