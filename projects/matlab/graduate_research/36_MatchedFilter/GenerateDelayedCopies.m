function y = GenerateDelayedCopies(x, n, d)

% Initialize x
y = zeros(n, length(x));

% Loop through the rows of the array and shift the array "d" samples each
% iteration
for i = 1:n
    y(i,:) = x;
    x = circshift(x, d);
    x(:,1:d) = 0;
end

% End ANN input generation function
end