function antideriv = ComputeGeneralizedSecantAntiderivative(j, a, b, xi)

sum_result = 0;

for k = 1:(j+1)
    
    plog_arg = 1i*exp(1i*b-a*xi);
    plog_factor = polylog(k, plog_arg) - polylog(k, -plog_arg);
    term = factorial(j) * xi^(j - k + 1) .* plog_factor ...
        / (a^k * factorial(j-k+1));
    sum_result = sum_result + term;
    
end

antideriv = 1i*sum_result;

end

