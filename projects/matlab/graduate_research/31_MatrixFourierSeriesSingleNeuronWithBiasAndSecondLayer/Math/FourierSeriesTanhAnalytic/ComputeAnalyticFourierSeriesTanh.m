function [a, b, c, n_fourier] = ComputeAnalyticFourierSeriesTanh( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns, ...
    omega, num_fourier_harmonics_n)

n_fourier = 0:num_fourier_harmonics_n;

% Real coefficients
a = zeros(size(n_fourier));

% Compute a(0)
a(1) = ComputeA0( ...
    gamma10_layer0, gamma11_layer0, gamma10_layer1, gamma11_layer1, ...
    alpha_coefs, number_partial_sum_terms_ns, omega);

% Compute a(n)
for idx = 2:length(n_fourier)
    a(idx) = ComputeAn( ...
        gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
        alpha_coefs, number_partial_sum_terms_ns, n_fourier(idx), omega);
end

% Imaginary coefficients
b = zeros(size(n_fourier));

for idx = 1:length(n_fourier)
    b(idx) = ComputeBn( ...
        gamma10_layer0, gamma11_layer0, gamma11_layer1, ...
        alpha_coefs, number_partial_sum_terms_ns, n_fourier(idx), omega);
end

c = sqrt(a.^2 + b.^2);

end
