%% ComputeNestedPolynomialCoefs
%% Computes the polynomial coefficients of h = f(g(t))
%
% @breif Computes coefs of h = f(g(t)) where f and g are polynomials
%
% @param[in] f_coefs - coefs of the outer polynomial, row vector, highest
% power first
%
% @param[in] g_coefs - coefs of the inner polynomial, row vector, highest
% power first
%
% @returns h_coefs - coefs of f(g(t)), row vector, highest power first
%

function h_coefs = ComputeNestedPolynomialCoefs(f_coefs, g_coefs)

convolution_exponent = length(f_coefs);

h_coefs = 0;

for idx = 1:length(f_coefs)
    coef = f_coefs(idx);
    convolution_exponent = convolution_exponent - 1;
    term = coef*ComputeConvolutionalPower(g_coefs, convolution_exponent);
    h_coefs = AddPolynomials(h_coefs, term);
end
