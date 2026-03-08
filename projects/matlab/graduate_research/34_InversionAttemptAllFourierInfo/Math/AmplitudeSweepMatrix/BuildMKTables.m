function [m_table, k_table] = BuildMKTables( ...
    number_partial_sum_terms_ns)

number_interrogation_points_big_p = ...
    number_partial_sum_terms_ns*(number_partial_sum_terms_ns + 1);

m_table = zeros(number_interrogation_points_big_p, 1);
k_table = zeros(number_interrogation_points_big_p, 1);

idx = 1;

for m = 1:number_partial_sum_terms_ns
    for k = 0:(2*m - 1)
        m_table(idx) = m;
        k_table(idx) = k;
        idx = idx + 1;
    end
end

end

