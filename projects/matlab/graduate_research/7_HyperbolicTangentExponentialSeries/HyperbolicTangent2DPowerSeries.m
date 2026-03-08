function [y] = HyperbolicTangent2DPowerSeries(x, M, N)

s = zeros(size(x));

for m=1:M
    for n=0:N 
        s = s + (-1)^m .* + (-2.*m.*abs(x)).^n./factorial(n);
    end
end

y = sign(x).*(1 + 2*s);
