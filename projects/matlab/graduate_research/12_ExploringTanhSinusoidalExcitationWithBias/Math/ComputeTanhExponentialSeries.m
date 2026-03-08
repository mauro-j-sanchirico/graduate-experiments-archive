function [y] = ComputeTanhExponentialSeries(x, M)

s = zeros(size(x));

% Epsilon dictates how soft the transition between 1 and -1 is for the
% signum function.  Using a large epsilon mitigates the discontinuities
% caused at transition points; using a small epsilon approximates the
% signum more accurately.  A heuristic is used to choose a good epsilon.

epsilon = 1/(2*sqrt(M));

for m=1:M
    s = s + (-1)^m .* exp(-2.*m.*x.*ComputeSignSquareRoot(x, epsilon)); 
end

y = ComputeSignSquareRoot(x, epsilon).*(1 + 2*s);

end
