%% ComputeTanhTaylorCoef
%
% @brief Computes a Taylor series coeffient for a cosine
%
% @param[in] m_index - the index of the Taylor coefficient
%
% @returns taylor_coef - the coefficient for the given index
%
function taylor_coef = ComputeCosTaylorCoef(m_index)
    taylor_coef = (-1)^(m_index) / factorial(2*m_index);
end
