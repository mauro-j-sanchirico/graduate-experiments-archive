function y = EvaluateCosTaylorSeries(v, taylor_coefs, number_terms_big_m)

sum = 0;

for m_index = 0:(number_terms_big_m-1)
    term = taylor_coefs(m_index+1)*(v).^(2*m_index);
    sum = sum + term;
end

y = sum;
