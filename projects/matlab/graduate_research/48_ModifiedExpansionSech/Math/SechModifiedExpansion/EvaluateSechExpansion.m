function y = EvaluateSechExpansion(v, alpha_coefs, number_terms_big_m)

sum = 0;

for m = 0:number_terms_big_m-1  
    term = alpha_coefs(m+1)*(v).^(2*m);
    sum = sum + term;
end

y = sum;
