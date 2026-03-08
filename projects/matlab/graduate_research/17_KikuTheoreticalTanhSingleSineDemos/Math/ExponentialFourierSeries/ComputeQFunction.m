function q = ComputeQFunction(m_idx, l_idx, factorial_table)
denom = LookupFactorial(l_idx, factorial_table);
numer = (-1)^(m_idx+l_idx)*2^(l_idx+1)*m_idx^l_idx;
q = numer/denom;
end
