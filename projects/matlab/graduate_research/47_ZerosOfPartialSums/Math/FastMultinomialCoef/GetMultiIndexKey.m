function k_key = GetMultiIndexKey(k)
base = 256;
exponents = 0:(length(k)-1);
multipliers = base.^exponents;
k_key = multipliers*k(:);
end
