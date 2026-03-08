function [definite_integral] = AnalyticGR2P662P4FixedBounds(a, m)

definite_integral = 0;

e0 = 1/2^(2*m);
e1 = exp(a*2*pi)/2^(2*m);

for k = 0:m
    
    q = (-1)^k/(a^2 + (2*k+1)^2);
    c = nchoosek(2*m+1, m-k);
    f = 2*k+1;
    
    definite_integral = definite_integral + q*c*f*(e0 - e1);
    
end

end
