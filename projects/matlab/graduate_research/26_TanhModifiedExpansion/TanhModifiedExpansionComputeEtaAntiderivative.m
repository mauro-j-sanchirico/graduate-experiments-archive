function big_eta_antiderivative = ...
    TanhModifiedExpansionComputeEtaAntiderivative(m, a, r)

sum = 0;
exponential = exp(a*r);

for k = 0:m
    sign_term = (-1)^k;
    polylog_delta = ...
        polylog(k+1, -exponential) - polylog(k+1, exponential);
    triangle_number = factorial(m)/factorial(m-k);
    term = sign_term.*triangle_number.*polylog_delta.*a^(-k-1)*r.^(m-k);
    sum = sum + term;
end

% The sum has a negligible imaginary component due to numerical effects.
% This component may be safely disgarded
big_eta_antiderivative = real(sum);

end
