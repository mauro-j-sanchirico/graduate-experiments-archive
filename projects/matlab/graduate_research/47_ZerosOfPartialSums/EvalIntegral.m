function y = EvalIntegral(x, k)
y = -(2^(2*k + 3)*sin(pi*(k/2 - 1/2))*sin((pi*k)/2)*gamma(k/2 + 3/2)*(gamma(k/2)*gamma(1 - k/2)*gamma(k/2 + 2)*hypergeom(1, [k/2 + 1, k/2 + 3/2], -x^2/4) - gamma(k/2 + 1)*gamma(1/2 - k/2)*gamma(k/2 + 1/2)*(x^2/4)^(1/2)*hypergeom(1, [k/2 + 2, k/2 + 3/2], -x^2/4))*(x/2)^(k + 1))/(pi^(3/2)*gamma(k + 1)*(k + 1)^2*(k + 2));
end

