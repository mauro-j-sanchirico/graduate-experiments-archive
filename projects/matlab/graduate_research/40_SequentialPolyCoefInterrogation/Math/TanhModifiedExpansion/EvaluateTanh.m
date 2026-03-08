function y = EvaluateTanh(v, alpha_coefs, number_terms_big_m)

sum = 0;

for m = 1:number_terms_big_m  
    term = alpha_coefs(m)*(v).^(2*m-1);
    sum = sum + term;
end

y = sum;
