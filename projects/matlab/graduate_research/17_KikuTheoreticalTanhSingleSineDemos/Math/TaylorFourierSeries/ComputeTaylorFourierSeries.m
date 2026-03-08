%% ComputeTaylorFourierSeries
%
% @brief Computes the Taylor Fourier Series of tanh(gamma*sin(psi))
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

function [a, b, c, n] = ComputeTaylorFourierSeries(gamma, N, M)

n = 0:N;

% Real coefficients are zero since unbiased tanh(sin(psi)) is odd
a = zeros(size(n));

% Imaginary coefficients
b = zeros(size(n));

bernoulli_table_struct = load('bernoulli_table.mat');
bernoulli_table = bernoulli_table_struct.bernoulli_table;

for i = 1:length(n)
    
    % Even coefficients are zero
    % Odd coefficients get populated
    if mod(n(i), 2) == 0
        b(i) = 0;
    else
        % Need to adjust the index since the formula is given in terms of
        % the nth odd coefficient, not the nth coefficient.  For example:
        % the 3rd coefficient is the 2nd odd coefficient (3+1)/2;
        odd_index = (n(i)+1)/2;
        b(i) = ComputeTaylorFourierBCoef( ...
                   odd_index, gamma, M, bernoulli_table);
    end
    
end

c = sqrt(a.^2 + b.^2);

end
