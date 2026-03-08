function y = ComputeTaylorSin(x, n_taylor_terms)
coefs = ComputeTaylorSinCoefs(n_taylor_terms);
y = polyval(coefs, x);
