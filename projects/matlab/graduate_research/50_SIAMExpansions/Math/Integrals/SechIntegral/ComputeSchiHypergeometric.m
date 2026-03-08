function y = ComputeSchiHypergeometric(n, z)

a = pi/2;
sum = 0;

for j = 0:n

    harg1 = [(1/2)*ones(1, j+1) 1];
    harg2 = (3/2)*ones(1, j+1);
    
    h = hypergeom(harg1, harg2, -exp(2*a*z));

    term = (-1)^j * z.^(n-j) * a^(-j-1) .* h ./ factorial(n - j);
    sum = sum + term;

end

y = 2*exp(a*z)*factorial(n).*sum;

end
