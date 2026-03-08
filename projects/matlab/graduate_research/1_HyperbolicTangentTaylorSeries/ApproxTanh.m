%% ApproxTanh
%
% @breif Vectorized computation of a Taylor series approximation to tanh
%
% @details Computes the matricies:
%
% x_matrix = [x1 ... xq    of size n x q where q is number of points in x
%             .  ... .     and n is the number of taylor terms
%             xn ... xnq]
%
% exponent_matrix = [1    ... 1     also of size n x q.
%                    3    ... 3
%                    2n-1 ... 2n-1]
%
% Then the tayor series is given by taking:
% y = a_coefs*x_matrix.^exponent_matrix
%
% @param[in] x - function to be input into the approximator (row vector)
%
% @param[in] n - number of terms in the expansion (not including even
% exponent terms which are excluded because the odd Bernoulli numbers that
% are attached to even exponents are 0).
%
% @returns y - the approximation of tanh(x)
%

function [y] = ApproxTanh(x, n)
number_of_data_points = length(x);
x_matrix = repmat(x, n, 1);
odd_idxs = 1:2:2*n;
exponent_matrix = repmat(odd_idxs', 1, number_of_data_points);
a_coefs = GetTanhCoefs(n);
y = a_coefs*x_matrix.^exponent_matrix;
end
