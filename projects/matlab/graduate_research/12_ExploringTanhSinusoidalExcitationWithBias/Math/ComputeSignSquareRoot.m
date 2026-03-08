function [y] = ComputeSignSquareRoot(x, epsilon)
y = x./sqrt(x.*x + epsilon.*epsilon);
end
