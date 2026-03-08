function big_i_an = ComputeBigIBnIntegral(k_index, n_fourier, omega)

dt = 0.001;
t = 0:dt:2*pi/omega;

integrand = (sin(omega*t).^k_index).*sin(n_fourier*omega*t);
integral = trapz(t, integrand);

big_i_an = integral;

end

