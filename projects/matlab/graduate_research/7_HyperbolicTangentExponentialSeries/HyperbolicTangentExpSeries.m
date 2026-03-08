function [y] = HyperbolicTangentExpSeries(x, M)

s = zeros(size(x));

for m=1:M
    s = s + (-1)^m .* exp(-2.*m.*abs(x)); 
end

y = sign(x).*(1 + 2*s);

end
