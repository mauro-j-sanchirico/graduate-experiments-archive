xi = 0:0.01:pi;
sum = zeros(size(xi));

for m = 1:M
    coef = ((-1)^(m-1))/factorial(2*m-1);
    term = coef*((xi).^(2*m-1));
    sum = sum + term;
end

plot(xi, sum)