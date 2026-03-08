function b = ComputeFourierCoefNumerical(n, gamma, dx)
x = 0:dx:pi;
y = tanh(gamma*sin(x));
fourier_integrand = y.*sin((2*n-1)*x);
fourier_integral = trapz(x, fourier_integrand);
b = fourier_integral;
end

