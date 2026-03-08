function y = EvaluateTanhTaylorSeries(v, taylor_coefs, number_terms_big_m)

sum = 0;

for m_index = 1:number_terms_big_m  
    term = taylor_coefs(m_index)*(v).^(2*m_index-1);
    sum = sum + term;
end

y = sum;
