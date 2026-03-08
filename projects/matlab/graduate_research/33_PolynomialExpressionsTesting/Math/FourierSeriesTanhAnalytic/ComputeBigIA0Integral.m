function big_i_a0 = ComputeBigIA0Integral(k, omega)

dt = 0.001;
t = 0:dt:2*pi/omega;

integrand = sin(omega*t).^(2*k);
integral = trapz(t, integrand);

big_i_a0 = integral;

end

