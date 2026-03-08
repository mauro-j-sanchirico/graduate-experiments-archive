function big_i_a0_vector = ...
    ConstructBigIa0Vector(number_partial_sum_terms_ns, omega)

k = (0:(number_partial_sum_terms_ns - 1))';

big_i_a0_vector = zeros(number_partial_sum_terms_ns, 1);

for idx = 1:length(k)
    big_i_a0_vector(idx) = ComputeBigIA0Integral(k(idx), omega);
end

end
