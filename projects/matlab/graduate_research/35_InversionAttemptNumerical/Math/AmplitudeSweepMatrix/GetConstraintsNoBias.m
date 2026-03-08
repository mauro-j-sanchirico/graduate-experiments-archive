function [aeq, beq] = GetConstraintsNoBias(number_partial_sum_terms_ns)

number_interrogation_points_big_p = ...
    number_partial_sum_terms_ns*(number_partial_sum_terms_ns + 1);

beq = zeros(number_interrogation_points_big_p, 1);
aeq = zeros( ...
    number_interrogation_points_big_p, number_interrogation_points_big_p);

aeq_row_idx = 1;

for m = 1:number_partial_sum_terms_ns
    for k = 0:(2*m - 1)
        %shin_vector(idx) = ...
        %    (w11_layer0^k)*(w10_layer0)^(2*m-1-k)*w11_layer1;
        
        if 2*m-1 > k
            aeq(aeq_row_idx, aeq_row_idx) = 1;
        end
        
        aeq_row_idx = aeq_row_idx + 1;
        
    end
end

end
