clc; clear; close all;

M = 20;
lhs_sum = 0;
rhs_odd_sum = 0;
rhs_even_sum = 0;
rhs_sum = 0;

for k = 0:(2*M-1)
    lhs_sum = lhs_sum + ComputeLittleF(k);
end

for k = 0:(M-1)
    rhs_odd_sum = rhs_odd_sum + ComputeLittleF(2*k+1);
end

for k = 0:(M-1)
    rhs_even_sum = rhs_even_sum + ComputeLittleF(2*k);
end

rhs_sum = rhs_even_sum + rhs_odd_sum;

lhs_sum
rhs_sum

function f = ComputeLittleF(k)
f = 0.1*k + 0.2;
end