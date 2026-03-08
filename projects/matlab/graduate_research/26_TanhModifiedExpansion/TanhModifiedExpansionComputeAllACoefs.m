function [a_coefs, integrals] = TanhModifiedExpansionComputeAllACoefs( ...
        max_v, epsilon, num_partial_sum_terms_ns)

a_coefs = zeros(1, num_partial_sum_terms_ns);
integrals = zeros(1, num_partial_sum_terms_ns);

for m = 1:num_partial_sum_terms_ns
    [a_coefs(m), integrals(m)] = TanhModifiedExpansionComputeACoef( ...
        m, max_v, epsilon, num_partial_sum_terms_ns);
end

end
