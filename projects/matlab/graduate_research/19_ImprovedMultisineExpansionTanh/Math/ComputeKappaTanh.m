function kappa_tanh = ComputeKappaTanh( ...
    p_power_of_taylor_term, r_range_of_taylor_validity)

mu_tanh = ComputeMuTanhDefIntegral( ...
    p_power_of_taylor_term, r_range_of_taylor_validity);

kappa_tanh = mu_tanh / factorial(vpa(p_power_of_taylor_term));

kappa_tanh = double(kappa_tanh);

end

