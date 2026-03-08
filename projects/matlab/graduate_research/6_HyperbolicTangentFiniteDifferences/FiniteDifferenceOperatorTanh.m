function [sum] = FiniteDifferenceOperatorTanh(n, h, x)

sum = 0;

for i=0:n
    sum = sum + ((-1)^i).*nchoosek(n, i).*tanh(x + (n-i).*h);
end

end
