%% AnalyticGR2P662P4
%
% @breif Analytically evaluates the Gradshteyn and Ryzhik rule 2.662,4
%
% @details The rule can be found on page 228 (page 277 in the PDF).
% Assumes that the lower bound is 0 and makes the cooresponding
% simplifications to the formulas.
%
% @param[in] x1 - The upper bound of the definite integral
%
% @param[in] a - Argument multiplier in the exponential factor
%
% @param[in] b - Argument multiplier in the sine factor
%
% @param[in] m - Integer used to generate the odd powers of the sine
%
% @returns definite_integral The value of the definite integral
%
function [definite_integral] = AnalyticGR2P662P4From0(x1, a, b, m)
definite_integral = 0;

e0 = 1/2^(2*m);
e1 = exp(a*x1)/2^(2*m);

for k = 0:m
   
    q = (-1)^k/(a^2 + (2*k+1)^2*b^2);
    c = nchoosek(2*m+1, m-k);
    f1 = a*sin((2*k+1)*b*x1) - (2*k+1)*b*cos((2*k+1)*b*x1);
    f0 = (2*k+1)*b;
    
    definite_integral = definite_integral + q*c*(e1*f1 + e0*f0);
    
end

end
