function kappa_tanh = ComputeKappaTanh(p)
kappa_tanh = ...
        ComputeMuTanhDefIntegral0InfAnalytical(vpa(p)) ...
      / factorial(vpa(p));
kappa_tanh = double(kappa_tanh);
end

