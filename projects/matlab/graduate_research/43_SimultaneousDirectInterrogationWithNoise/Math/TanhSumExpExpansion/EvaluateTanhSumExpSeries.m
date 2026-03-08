function y = EvaluateTanhSumExpSeries( ...
    v, sum_exp_coefs, m_index_max)

sum = 0;

for m_index = 0:m_index_max
    sum = sum + sum_exp_coefs(m_index + 1).*abs(v).^m_index;
end

y = sign(v).*(1 + 2*sum);
