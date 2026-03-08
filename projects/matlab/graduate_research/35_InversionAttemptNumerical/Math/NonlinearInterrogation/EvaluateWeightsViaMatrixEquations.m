function mean_square_error = EvaluateWeightsViaMatrixEquations( ...
    w_vector, big_a_matrix, f_vector, number_partial_sum_terms_ns)

w10_layer0 = w_vector(1);
w11_layer0 = w_vector(2);
w11_layer1 = w_vector(3);

shin_vector = ComputeShinVector( ...
    number_partial_sum_terms_ns, w10_layer0, w11_layer0, w11_layer1);

error_vector = big_a_matrix*shin_vector - f_vector;

mean_square_error = sum(error_vector.^2)/length(error_vector);

end
