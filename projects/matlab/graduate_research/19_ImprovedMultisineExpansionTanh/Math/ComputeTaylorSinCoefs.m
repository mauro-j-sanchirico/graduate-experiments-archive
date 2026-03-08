function coefs = ComputeTaylorSinCoefs(n_taylor_terms)

coefs = zeros(1, n_taylor_terms*2);
n = n_taylor_terms*2-1:-1:0;

for idx = 1:length(coefs)
    
    if mod(n(idx), 2) == 0
        coefs(idx) = 0;
    else
        coefs(idx) = double((-1)^((n(idx)-1)/2)/factorial(n(idx)));
    end
    
end

end

