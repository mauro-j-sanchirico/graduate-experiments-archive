function tanh_v = TanhModifiedExpansionEvaluate(a_coefs, v)

sum = zeros(size(v));

for m=1:length(a_coefs)
    sum = sum + a_coefs(m)*v.^(2*m-1);
end

tanh_v = sum;

end

