function y = EvaluateTanh(v, alpha_coefs, number_partial_sum_terms_ns)

sum = 0;

for m = 1:number_partial_sum_terms_ns  
    term = alpha_coefs(m)*(v).^(2*m-1);
    sum = sum + term;
end

y = sum;
