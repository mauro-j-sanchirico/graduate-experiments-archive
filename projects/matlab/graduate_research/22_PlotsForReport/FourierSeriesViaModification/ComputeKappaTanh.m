function kappa_tanh = ComputeKappaTanh( ...
    p_power_of_taylor_term, r_range_of_taylor_validity)

phi_tanh = ComputePhiTanhDefIntegral( ...
    p_power_of_taylor_term, r_range_of_taylor_validity);

kappa_tanh = phi_tanh / factorial(vpa(p_power_of_taylor_term));

kappa_tanh = double(kappa_tanh);

end

