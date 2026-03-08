function [theta] = GetVRoots(gamma, omega, phi)

% Modulus is a sawtooth function and can be computed analytically via
% fourier series.

t1 = mod((-asin(-gamma(1)/gamma(2)) - phi + pi)/omega, 2*pi/omega);
t2 = mod((asin(-gamma(1)/gamma(2)) - phi)/omega, 2*pi/omega);

% This step will reorder the zeros analytically so theta0 is less than
% theta1; but it only works for phi = 0
z1 = ComputeHeaviside0AtOrigin(gamma(1)/gamma(2));
z2 = ComputeHeaviside1AtOrigin(-gamma(1)/gamma(2));

t = [t1;
     t2];

Z = [z1 z2;
     z2 z1];

theta = Z*t;

end
