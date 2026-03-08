function m_expansion_params = GetModifiedExpansionParams()

m_expansion_params.m_index_max = 40; % Maximum exponent in polynomial
m_expansion_params.epsilon = eps;    % Small number used to compute limits (use machine eps)
m_expansion_params.dxi = 1e-5;       % Differential used for approximate integrals
m_expansion_params.max_v = 5.5;      % Maximum expected input
m_expansion_params.numerical_integral_flag = true; % True - faster than symbolic integrals

end
