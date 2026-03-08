%% ComputeNumericalFourierSeries
%
% @breif Computes the Fourier Series numerically
%
% @details y and t should be of the same length, and represent one period
% of a periodic function such that t(end) - t(1) = T;
%
% @param[in] t - Time
%
% @param[in] y - Function
%
% @param[in] N - Max number of harmonics
%
% @returns Real coefs (a), imag coefs (b), and coef numbers n = 0:N-1;
%

function [a, b, n] = ComputeNumericalFourierSeries(t, y, N)

n = 0:N;

T = t(end) - t(1);

omega = 2*pi/T;

% Real coefficients
a = zeros(size(n));

for i = 1:length(n)
    integrand = y.*cos(omega.*n(i).*t);
    integral = trapz(t,integrand);
    a(i) = omega/pi*integral;
end

% Imaginary coefficients

b = zeros(size(n));

for i = 1:length(n)
    integrand = y.*sin(omega.*n(i).*t);
    integral = trapz(t,integrand);
    b(i) = omega/pi*integral;
end

end

