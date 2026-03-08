function integral = ComputeGeneralizedSecantIntegral(j, a, b, xi0, xi1)

integral = ComputeGeneralizedSecantAntiderivative(j, a, b, xi1) ...
    - ComputeGeneralizedSecantAntiderivative(j, a, b, xi0);

end

