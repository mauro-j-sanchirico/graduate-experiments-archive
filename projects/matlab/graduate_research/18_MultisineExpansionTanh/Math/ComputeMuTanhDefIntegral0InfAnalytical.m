function Mu_integral = ComputeMuTanhDefIntegral0InfAnalytical(p)

beta = p + 1;
a = pi/2;

numerator = (2^vpa(beta) - vpa(1))*gamma(vpa(beta))*zeta(vpa(beta));
denominator = 2^(vpa(beta) - vpa(1))*a^vpa(beta);

Mu_integral = numerator / denominator;

end


