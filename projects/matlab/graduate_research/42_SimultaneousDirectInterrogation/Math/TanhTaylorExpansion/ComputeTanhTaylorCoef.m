%% ComputeTanhTaylorCoef
%
% @brief Computes a Taylor series coeffient for the hyperbolic tangent
%
% @details Computes a Taylor series coeffient according to the standard
% Taylor series expansion of the hyperbolic tangent.
%
% @param[in] m_index - the index of the Taylor coefficient
%
% @returns taylor_coef - the coefficient for the given index
%

function taylor_coef = ComputeTanhTaylorCoef(m_index)

numerator = 2.^(2*m_index)*(2.^(2.*m_index) - 1).*bernoulli(2.*m_index);
denominator = factorial(2*m_index);

taylor_coef = numerator / denominator;

end

