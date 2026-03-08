%% ComputeNumericalFourierSeries
%
% @brief Computes the Fourier Series using Theorem 1 following the method
% of "On multisine excitation of sigmoidal nonlinearities" (Sanchirico)
% 8/11/19.
%
% @param[in] t - Time
%
% @param[in] v - Input to nonlinearity
%
% @param[in] N_f - Max number of harmonics
%
% @param[in] N_t - Max number of taylor terms
%
% @returns Real coefs (a), imag coefs (b), magnitudes (c), and coef
% numbers n = 0:N-1
%

function [a, b, c, n] = ComputeTheorem1FourierSeries(t, v, N_f, N_t, gamma_1)

n = 0:(N_f - 1);
k = 0:(N_t - 1);

T = t(end) - t(1);

omega = 2*pi/T;

% Real coefficients
a = zeros(size(n));

for n_idx = 1:length(n)
    sum = 0;
    for k_idx = 1:length(k)
        integrand = v.^(1+2*k(k_idx)).*cos(omega.*n(n_idx).*t);
        integral = trapz(t, integrand);
        term = (-1)^k(k_idx)*ComputeKappaTanh(1+2*k(k_idx))*integral;
        sum = sum + term;
    end
    a(n_idx) = omega*gamma_1/pi*sum;
end

% Imaginary coefficients
b = zeros(size(n));

for n_idx = 1:length(n)
    sum = 0;
    for k_idx = 1:length(k)
        integrand = v.^(1+2*k(k_idx)).*sin(omega.*n(n_idx).*t);
        integral = trapz(t, integrand);
        term = (-1)^k(k_idx)*ComputeKappaTanh(1+2*k(k_idx))*integral;
        sum = sum + term;
    end
    b(n_idx) = omega*gamma_1/pi*sum;
end

c = sqrt(a.^2 + b.^2);

end
