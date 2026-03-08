function big_i_an = ComputeBigIAnIntegral(k, n, omega)

dt = 0.001;
t = 0:dt:2*pi/omega;

integrand = (sin(omega*t).^k).*cos(n*omega*t);
integral = trapz(t, integrand);

big_i_an = integral;

end
