%% ComputeExponentialFourierSeries
%
% @brief Computes the Exponential Fourier Series of tanh(gamma*sin(psi))
%
% @param[in] gamma - Gain as seen by tanh()
%
% @param[in] N - Max number of harmonics
%
% @param[in] M - Max number of inner summation terms
%
% @returns Real coefs (a), imag coefs (b), magnitudes (c), and coef
% numbers n = 0:N
%

function [a, b, c, n] = ComputeExponentialFourierSeries(gamma, N, M, L)

n = 0:N;

% Real coefficients are zero since unbiased tanh(sin(psi)) is odd
a = zeros(size(n));

% Imaginary coefficients
b = zeros(size(n));

% Mu table
mu_table_struct = load('mu_table.mat');
mu_table = double(mu_table_struct.mu_table);

% Q Table
q_table_struct = load('q_table.mat');
q_table = double(q_table_struct.q_table);

for i = 1:length(n)
    
    % Even coefficients are zero
    % Odd coefficients get populated
    if mod(n(i), 2) == 0
        b(i) = 0;
    else
        odd_index = (n(i) + 1)/2;
        b(i) = 2/pi*ComputeExponentialFourierBCoef( ...
            odd_index, gamma, M, L, mu_table, q_table);
    end
    
end

c = sqrt(a.^2 + b.^2);

end
