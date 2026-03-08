function polynomial_system = ...
    ConvertFundamentalMLPToPolynomialSystem(x, y, alpha_coefs)

number_terms_big_m = floor(length(alpha_coefs)/2);
alpha_coefs = fliplr(alpha_coefs);

polynomial_system = {};

for n = 1:length(x)
    
    coefs = [];
    exps = [];
    
    % y term
    coefs = [coefs, y(n)];
    exps = [exps; 0 0 0 0];
    
    % w0_layer1 term
    coefs = [coefs 1];
    exps = [exps; [0, 0, 1, 0]];
    
    for m = 1:number_terms_big_m
        j = 2*m - 1;
        alpha_idx = j + 1;
        for k = 0:j
            coefs = [coefs, nchoosek(j,k)*alpha_coefs(alpha_idx)*x(n)^k];
            exps = [exps; (j-k), k, 0, 1]; % w0L0, w1L0, w0L1, w1L1
        end
    end
    
    polynomial_system{n, 1} = coefs;
    polynomial_system{n, 2} = exps;
    
end

end
