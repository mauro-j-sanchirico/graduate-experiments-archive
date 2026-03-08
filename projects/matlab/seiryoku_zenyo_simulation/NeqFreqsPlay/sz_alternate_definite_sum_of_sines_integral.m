clc; clear; close all

freqs = [1 25/24 9/8 6/5 5/4 4/3 45/32 3/2 8/5 5/3 9/5 15/8 2];

sz = freqs.*0;

for i = 1:length(freqs);
RAD_TO_DEG = 180/pi;

% Uke Parameters
A_U = 1;
f_U = 1;
phi_U = 0;

w_U = 2*pi*f_U;
P_U = 1/f_U;

% Tori Parameters
A_T = 1;
f_T = freqs(i);
phi_T = 0;

w_T = 2*pi*f_T;
P_T = 1/f_T;

% Computing the Peroiod of the sum geometrically
[N_U, D_U] = rat(P_U);
[N_T, D_T] = rat(P_T);

lcm(D_U, D_T);
gcd(N_U, N_T);

P = lcm(N_U, N_T)/gcd(D_U, D_T);

tmin = 0;
tmax = P;

% integral bounds:
a = tmin;
b = tmax;

sz(i) = ...
( sign(A_U*sin(w_U*a-phi_U)+A_T*sin(w_T*a-phi_T))*A_U*cos(w_U*a-phi_U)*w_T ...
 +sign(A_U*sin(w_U*a-phi_U)+A_T*sin(w_T*a-phi_T))*A_T*cos(w_T*a-phi_T)*w_U ...
 -sign(A_U*sin(w_U*b-phi_U)+A_T*sin(w_T*b-phi_T))*A_U*cos(w_U*b-phi_U)*w_T ...
 -sign(A_U*sin(w_U*b-phi_U)+A_T*sin(w_T*b-phi_T))*A_T*cos(w_T*b-phi_T)*w_U)/(w_U*w_T);

end

figure(2)
plot(freqs, sz);

[X, I] = sort(sz, 'descend');

[N, D] = rat(freqs(I));

fprintf('Ratios in order:\n');

for i=1:length(N)
   fprintf('%i/%i..........%f\n', N(i), D(i),X(i));
end

