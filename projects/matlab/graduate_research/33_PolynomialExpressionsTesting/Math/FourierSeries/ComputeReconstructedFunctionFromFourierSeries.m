function y_approx = ...
    ComputeReconstructedFunctionFromFourierSeries(a, b, n, t)

T = t(end) - t(1);

omega = 2*pi/T;

% a0 term
y_approx = 0.5*a(1);

for i = 2:length(n)
    
    term = a(i)*cos(omega.*n(i).*t) + b(i)*sin(omega.*n(i).*t);
    
    y_approx = y_approx + term;

end
