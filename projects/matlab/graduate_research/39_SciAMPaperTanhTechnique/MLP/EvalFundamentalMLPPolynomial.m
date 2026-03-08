function y = EvalFundamentalMLPPolynomial( ...
    w0_layer1, w1_layer1, w0_layer0, w1_layer0, x, alpha_coefs)

number_terms_big_m = floor(length(alpha_coefs)/2);
z = zeros(size(x), class(x));
outer_sum = z;

alpha_coefs = fliplr(alpha_coefs);

for m = 1:number_terms_big_m
    inner_sum = z;
    j = 2*m - 1;
    for k = 0:j
        inner_sum = ...
            inner_sum + nchoosek(j,k)*w0_layer0^(j-k)*w1_layer0^k*x.^k;
    end
    alpha_idx = j + 1;
    outer_sum = outer_sum + alpha_coefs(alpha_idx)*inner_sum;
end

y = w0_layer1 + w1_layer1*outer_sum;

end
