function VisualizeModifiedExpansionIntegrands()

big_m = 10;

dxi = 0.1;
xi = dxi:dxi:100;

% Visualize the integrands
figure;
for m = 1:big_m
    integrand = xi.^(2*m-1).*csch(xi*pi/2);
    loglog(xi, integrand, 'k');
    hold on;
end

grid on;
grid minor;
xlabel('$$\xi$$');
ylabel('$$f(\xi)$$')
title('$$f(\xi) = \xi^{2m-1}$$csch$$(\frac{\pi}{2}\xi)$$, $$m = 1...10$$');
saveas(gcf, './Images/CschIntegrals.png');

dxi = 0.01;
xi = 0.000001:dxi:30;

% Visualize the integrals
figure;
for m = 1:10
    integrand = xi.^(2*m-1).*csch(xi*pi/2);
    cumsum_integral = cumsum(integrand)*dxi;
    integral = (2^(2*m) - 1)/(2*m)*2^(2*m)*abs(bernoulli(2*m));
    fraction_captured = cumsum_integral/integral;
    plot(xi, fraction_captured, 'k');
    hold on;
end

grid on;
grid minor;
xlabel('$$u$$');
ylabel('$$\kappa(u)$$')
title('$$\frac{\int_0^u \! f(\xi) \, \mathrm{d}x}{\int_0^\infty \! f(\xi)\, \mathrm{d}x}$$, $$f(\xi) = \xi^{2m-1}\mathrm{csch}(\frac{\pi}{2}\xi)$$, $$m = 1...10$$');
saveas(gcf, './Images/FractionOfIntegrals.png');

end

