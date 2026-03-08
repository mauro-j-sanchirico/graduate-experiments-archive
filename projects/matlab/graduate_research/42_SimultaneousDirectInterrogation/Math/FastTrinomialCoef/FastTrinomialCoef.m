function c = FastTrinomialCoef(tc_table, n, k)
c = tc_table{n}(k(1)+1, k(2)+1, k(3)+1);
end

