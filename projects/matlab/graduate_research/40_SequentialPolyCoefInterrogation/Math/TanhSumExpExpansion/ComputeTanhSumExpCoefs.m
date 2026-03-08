%% ComputeTanhSumExpCoefs
%
% @breif Computes the sum of exponentials expansion coeffcients of the
% hyperbolic tangent
% @param[in] m_index_max - the maximum m_index to use in the outer sum
% @param[in] l_index_max - the maximum l_index to use in the inner sum
% @returns sum_exp_coefs - the coefficients of the Taylor series expansion
%

function sum_exp_coefs = ComputeTanhSumExpCoefs(m_index_max, l_index_max)

sum_exp_coefs = zeros(1, m_index_max);

for m_index = 0:m_index_max
    sum_exp_coefs(m_index+1) = ...
        ComputeTanhSumExpCoef(m_index, l_index_max);
end

end

