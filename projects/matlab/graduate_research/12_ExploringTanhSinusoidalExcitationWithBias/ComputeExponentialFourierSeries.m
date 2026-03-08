%% ComputeExponentialFourierSeries
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
% @param[in] M - Max number of exponential terms
%
% @returns Real coefs (a), imag coefs (b), and coef numbers n = 0:N-1;
%

function [a, b, n] = ComputeExponentialFourierSeries( ...
    t, gamma0, gamma1, omega1, phi1, N, M)

n = 0:N;
m = 1:M;

% Epsilon required to approximate the signum
%
% An analytic approximation to the signum is used to keep the formula
% analytic for proofs later on.
%
epsilon = 1/(2*sqrt(M));

% Argument to the tanh
psi1 = omega1*t + phi1;
v = gamma0 + gamma1*sin(psi1);
abs_v = v.*ComputeSignSquareRoot(v, epsilon);


% Real coefficients
a = zeros(size(n));

for i = 1:length(n)
    sum = 0;
    harmonic = cos(n(i).*omega1.*t);
    
    for j=1:length(m)
        sum = sum + (-1).^m(j) .* exp(-2.*m(j).*abs_v); 
    end

    sign_term = ComputeSignSquareRoot(v, epsilon);
    y = sign_term.*(1 + 2*sum);
    
    integrand = y.*harmonic;
    integral = trapz(t, integrand);
    
    a(i) = omega1/pi.*integral;
end

% Imaginary coefficients

b = zeros(size(n));

for i = 1:length(n)
    sum = 0;
    harmonic = sin(n(i).*omega1.*t);
    
    for j=1:length(m)
        sum = sum + (-1).^m(j) .* exp(-2.*m(j).*abs_v); 
    end

    sign_term = ComputeSignSquareRoot(v, epsilon);
    y = sign_term.*(1 + 2*sum);
    
    integrand = y.*harmonic;
    integral = trapz(t, integrand);
    
    b(i) = omega1/pi.*integral;
end

end
