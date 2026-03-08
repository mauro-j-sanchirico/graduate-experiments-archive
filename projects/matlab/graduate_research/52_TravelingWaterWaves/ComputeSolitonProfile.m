function u = ComputeSolitonProfile(k, v, b, x, x0, t)

u = 12*b*k^2*sech(k*((x-x0) - v*t)).^2;

end

