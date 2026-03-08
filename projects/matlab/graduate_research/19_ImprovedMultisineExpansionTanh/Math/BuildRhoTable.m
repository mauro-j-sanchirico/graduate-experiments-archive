%% Build Rho Table
%% Table of Range of Taylor Sin Validity wrt. Number of Terms

clc; clear; close all;

k = 1:50;
rho_range = zeros(size(k));

for idx = 1:length(k)

    coefs = ComputeTaylorSinCoefs(k(idx));
    rho_roots = roots(coefs);
    rho_real = real(rho_roots(imag(rho_roots) < eps));
    rho_real_max = max(rho_real);
    rho_range(idx) = rho_real_max;
    
end

r_linear_fit_coefs = polyfit(k(10:end), rho_range(10:end), 1);
rho_linear_fit_range = polyval(r_linear_fit_coefs, k);

figure;
plot(k, rho_range, 'ko');
hold on;
plot(k, rho_linear_fit_range, 'k-');
grid on;
title('Range of Validity for Taylor Series of Sinusoid');
xlabel('Number of Terms');
ylabel('Range of Validity');
legend('Largest Real Root', 'Linear Fit');

save('LookupTables/rho_range.mat', 'rho_range');
save('LookupTables/r_linear_fit_coefs.mat', 'r_linear_fit_coefs');
