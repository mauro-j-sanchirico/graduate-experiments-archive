%% ComputeMultiIndexPower
%
% @breif Raises x to the power of multi-index k
%
% @details Multi-index powers are computed as follows:
%
% x = [x1 x2 ... xn]
% k = [k1 k2 ... kn]
%
% y = x1^k1 * x2^k2 * ... * xn^kn
%
% @param[in] x - column vector with number of elements equal to number of
% elements in k or matrix with number of rows equal to number of elements
% in k
%
% @param[in] k - vector of multi-index exponents with length equal to the
% number of elements in x if x is a column vector or with length equal to 
% the number of rows in x if x is a matrix.
%
% @returns y - x raised to the multi-index exponent k
%

function y = ComputeMultiIndexPower(x,k)
k = k(:);
y = prod(bsxfun(@power,x,k));
end

