function [big_beta_vector_from_matricies, ...
          big_beta_a0_vector_from_matricies] = ...
    ConstructBigBetaVectorsFromMatricies(big_alpha_matrix, big_g_matrix)

big_beta_vector_from_matricies = diag(big_alpha_matrix*(big_g_matrix'));

% Only the even elements of the big beta vector are used for the big
% vector that helps compute a0 (i.e. 2*k, k = 0...M-1)
big_beta_a0_vector_from_matricies = ...
    big_beta_vector_from_matricies(1:2:end);

end
