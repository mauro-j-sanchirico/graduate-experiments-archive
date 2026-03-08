%% ComputeExponentialFourierSeries
%
% @brief Computes the Kappa Fourier Series of tanh(gamma*sin(psi))
%
% @details Note - the M parameter that was used to build the kappa
% table is a predetermined parameter and cannot be changed at runtime
% of this function.  If a different M is desired, the kappa table must
% be rebuilt.
%
% @param[in] gamma - Gain as seen by tanh()
%
% @param[in] N - Max number of harmonics
%
% @param[in] L - Max number of taylor series terms
%
% @param[in] kappa_table - Table of the precomputed kappa coefficients
%
% @returns Real coefs (a), imag coefs (b), magnitudes (c), and coef
% numbers n = 0:N
%

function [a, b, c, n] = ComputeKappaFourierSeries(gamma, N, L)

n = 0:N;

% Real coefficients are zero since unbiased tanh(sin(psi)) is odd
a = zeros(size(n));

% Imaginary coefficients
b = zeros(size(n));

% Kappa table
kappa_table_struct = load('kappa_table.mat');
kappa_table = double(kappa_table_struct.kappa_table);

% Downselect the portion of the kappa matrix for the given parameters
n_start = 1;
L_start = 0;
kappa_matrix = kappa_table(n_start+1:N+1, L_start+1:L+1);

% Construct the gamma powers vector
gamma_powers = gamma.^(0:L);
gamma_powers = gamma_powers';

% Construct the beta naught vector
b_0 = 2./(2*(1:N)-1);
b_0 = b_0';

% Apply the Kappa Theorem
b_odd = kappa_matrix*gamma_powers + b_0;

% Standardize the indicies
for i = 1:length(n)
    
    % Even coefficients are zero
    % Odd coefficients get populated
    if mod(n(i), 2) == 0
        b(i) = 0;
    else
        odd_index = (n(i) + 1)/2;
        b(i) = b_odd(odd_index)*2/pi;
    end
    
end

c = sqrt(a.^2 + b.^2);

end
