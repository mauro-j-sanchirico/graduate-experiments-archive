%% ComputeTanhTaylorCoef
%
% @brief Computes a Taylor series coeffient for a sinusoid
%
% @param[in] m_index - the index of the Taylor coefficient
%
% @returns taylor_coef - the coefficient for the given index
%
function taylor_coef = ComputeSinTaylorCoef(m_index)
    taylor_coef = (-1)^(m_index - 1) / factorial(2*m_index - 1);
end
