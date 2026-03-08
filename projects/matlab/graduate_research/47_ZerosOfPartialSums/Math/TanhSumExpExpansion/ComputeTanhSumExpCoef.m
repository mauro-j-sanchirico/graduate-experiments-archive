%% ComputeTanhSumExpCoef
%
% @brief Computes a sum of exponentials coefficient for tanh
%
% @details Computes a coefficient for the series expansion of the
% hyperbolic tangent which is derived by expanding the hyperbolic tangent
% as a sum of exponentials and then expanding each exponential via taylor
% series.
%
% @param[in] m_index - the index of the coefficient
%
% @param[in] l_index_max - the maximum index of the inner summation
%
% @returns a coefficient for the sum of exponentials expansion for the
% given m_index
%
function sum_exp_coef = ComputeTanhSumExpCoef(m_index, l_index_max)

sum_exp_coef = 0;

for l_index = 1:l_index_max
    sign_factor = (-1)^(m_index+l_index);
    term = sign_factor*((2.*l_index).^m_index)./factorial(m_index);
    sum_exp_coef = sum_exp_coef + term;
end

end
