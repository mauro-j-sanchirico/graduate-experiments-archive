function coefs = ComputeTaylorNthCoefSech2(n)
coefs = zeros(size(n));
evens = mod(n, 2) == 0;
numer = 2.^(n(evens)+1) ...
    .* (4.^(n(evens)./2 + 1) - 1) ...
    .* bernoulli(n(evens) + 2);
denom = (n(evens)./2 + 1) .* factorial(n(evens));
coefs(evens) = numer ./ denom;
end

