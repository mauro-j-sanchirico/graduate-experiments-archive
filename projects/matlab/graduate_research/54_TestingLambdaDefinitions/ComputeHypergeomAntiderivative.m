function lambda_val = ComputeHypergeomAntiderivative(j, a, zeta)

sum_result = 0;

for k = 0:j
    harg1 = [(1/2)*ones(1, k+1) 1];
    harg2 = (3/2)*ones(1, k+1);
    h = hypergeom(harg1, harg2, -zeta.^2);
    term = (-1)^k .* log(zeta).^(j-k) .* h ./ (factorial(j-k) .* a^(j+1));
    sum_result = sum_result + term;
end

lambda_val = 2 * j * zeta .* sum_result;

end
