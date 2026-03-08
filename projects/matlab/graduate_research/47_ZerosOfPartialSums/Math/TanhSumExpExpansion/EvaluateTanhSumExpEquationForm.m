function EvaluateTanhSumExpEquationForm(m_index_max, l_index_max, u)
outer_sum = 0;
for m_index = 0:m_index_max
    big_e_m = 0;
    for l_index = 1:l_index_max
        sign_factor = (-1)^(l_index + m_index);
        term = sign_factor*(2*l_index)^m_index/factorial(m_index);
        big_e_m = big_e_m + term;
    end
    if m_index == 0
        big_e_m = 1 + 2*big_e_m;
    else
        big_e_m = 2*big_e_m;
    end
    outer_sum = outer_sum + big_e_m*u.^m_index;
end
