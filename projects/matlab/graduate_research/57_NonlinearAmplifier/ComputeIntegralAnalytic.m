function y = ComputeIntegralAnalytic(d, g, m)

gamma_factor_num = -sqrt(pi)*sqrt(g/(g-d))*sqrt(g/(d+g))*gamma(2*m+3);
gamma_factor_denom = g*(m+1)*gamma(2*m+5/2);

gamma_factor = gamma_factor_num / gamma_factor_denom;

hyper_factor1 = ...
    (d-g)^(2*m+2)*hypergeom([1/2, 2*(m+1)], 2*m+5/2, (d-g)/(d+g));

hyper_factor2 = ...
    (d+g)^(2*m+2)*hypergeom([1/2, 2*(m+1)], 2*m+5/2, (d+g)/(d-g));

y = gamma_factor*hyper_factor1*hyper_factor2;

end
