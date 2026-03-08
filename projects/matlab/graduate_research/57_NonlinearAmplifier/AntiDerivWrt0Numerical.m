function y = AntiDerivWrt0Numerical(d, g, m, t1)
dt = 0.001;
t = 0:dt:t1;
integrand = (d + g*sin(t)).^(2*m+1);
y = trapz(t, integrand);
end

