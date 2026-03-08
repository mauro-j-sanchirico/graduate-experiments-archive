function c = AddPolynomials(a, b)

max_len = max([length(a), length(b)]);
a = [zeros(1, max_len - length(a)), a];
b = [zeros(1, max_len - length(b)), b];
c = a + b ;
end
