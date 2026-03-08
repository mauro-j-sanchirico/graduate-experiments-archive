%% ComputeModifiedFourierSeries
%
% @brief Computes the Fourier Series following the method of "On multisine
% excitation of sigmoidal nonlinearities" (Sanchirico) 8/11/19.
%
% @param[in] gamma - gain at input to nonlinearity
%
%
% @param[in] N_f - Max number of harmonics
%
% @param[in] N_t - Max number of taylor terms
%
% @param[in] r_range_of_taylor_validity - Range in which Taylor Series
% converges
%
% @param[in] t - time
%
% @returns Real coefs (a), imag coefs (b), magnitudes (c), and coef
% numbers n = 0:N-1
%

function [a, b, c, n] = ComputeModifiedFourierSeries( ...
    gamma, N_f, N_t, r_range_of_taylor_validity, t)

v = gamma*sin(t);

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
        kappa = ...
            ComputeKappaTanh(1+2*k(k_idx), r_range_of_taylor_validity);
        term = (-1)^k(k_idx)*kappa*integral;
        sum = sum + term;
    end
    a(n_idx) = omega/pi*sum;
end

% Imaginary coefficients
b = zeros(size(n));

for n_idx = 1:length(n)
    sum = 0;
    for k_idx = 1:length(k)
        integrand = v.^(1+2*k(k_idx)).*sin(omega.*n(n_idx).*t);
        integral = trapz(t, integrand);
        kappa = ...
            ComputeKappaTanh(1+2*k(k_idx), r_range_of_taylor_validity);
        term = (-1)^k(k_idx)*kappa*integral;
        sum = sum + term;
    end
    b(n_idx) = omega/pi*sum;
end

c = sqrt(a.^2 + b.^2);

end
