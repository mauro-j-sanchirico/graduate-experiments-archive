function shin_vector = ComputeShinVector( ...
    number_partial_sum_terms_ns, w10_layer0, w11_layer0, w11_layer1)

number_interrogation_points_big_p = ...
    number_partial_sum_terms_ns*(number_partial_sum_terms_ns + 1);

shin_vector = zeros(number_interrogation_points_big_p, 1);

idx = 1;

for m = 1:number_partial_sum_terms_ns
    for k = 0:(2*m - 1)
        shin_vector(idx) = ...
            (w11_layer0^k)*(w10_layer0)^(2*m-1-k)*w11_layer1;
        idx = idx + 1;
    end
end

end

