function y = ComputeTanhExpSeries(v, M)

y = zeros(size(v));

sum = zeros(size(v));

for m = 1:M
    sum = sum + (-1).^m*exp(-2*m*abs(v));
end

v_greater_than_zero = v > eps;
v_equal_to_zero = abs(v) <= eps;
v_less_than_zero = v < -eps;

y(v_greater_than_zero) = 1 + 2*sum(v_greater_than_zero);
y(v_equal_to_zero) = 0;
y(v_less_than_zero) = -1 - 2*sum(v_less_than_zero);

end
