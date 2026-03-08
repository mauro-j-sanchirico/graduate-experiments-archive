function coefs = ComputeTaylorNthCoefSech(n_list)
coefs = zeros(size(n_list));
evens = mod(n_list, 2) == 0;
coefs(evens) = euler(n_list(evens))./factorial(n_list(evens));
end
