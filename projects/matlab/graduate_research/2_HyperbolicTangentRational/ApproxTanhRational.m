%% ApproxTanhRational
%
% @breif Vectorized computation of a rational series approximation to tanh
%
% @details Applies the formula:
%  
% tanh(v) = (8*v/pi^2) * SUM [k=1...inf] 1 / ((2k-1)^2 + (4/pi^2)*v^2)
%
% The formula is 1.421, 2.10 in Gradshteyn and Ryzhik and can be found on
% page 44 (page 93 in the PDF).
% 
% @param[in] x - function to be input into the approximator (row vector)
%
% @param[in] n - number of terms in the expansion
%
% @returns y - the approximation of tanh(x)
%

function [y] = ApproxTanhRational(x, n)
number_of_data_points = length(x);
x_matrix = repmat(x, n, 1);
k_values = 1:n;
k_matrix = repmat(k_values', 1, number_of_data_points);
pi2 = pi*pi;
y = (8.*x./pi2).*sum(1./((2.*k_matrix-1).^2 + (4./pi2).*x_matrix.^2));
end
