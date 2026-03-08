%% Exploration of transcendental roots
%
% @file arcsinsinplay2.m
%
% @brief In this file, transcendental roots are explored
%

t_min = -10*pi;
t_max = 10*pi;
d_t = 0.001;

t = t_min:d_t:t_max;

A_U = 1;
phi_U = 0;
w_U = 1;

A_T = 2;
phi_T = 0;
w_T = 0:0.001:2;

time_points = [];
freq_points = [];

for k = 1:length(A_T)
figure(k)
for j = 1:length(w_T)
j
F_U = A_U.*sin(w_U.*t - phi_U);
F_T = A_T(k).*sin(w_T(j).*t - phi_T);

F_R = F_U + F_T;

C=0;
C_t = t.*0 + C;

%plot(t, F_R);
hold on
%plot(t, C_t);

i = find(abs(F_R - C_t) < 0.001);
%i = find(abs(gradient(sign(F_R))) == 1);


pt = t(i);
py = F_R(i) +w_T(j);

time_points = [time_points pt];
freq_points = [freq_points py];


plot(pt, py, 'ro', 'MarkerSize', 1);
%plot(pt, pi./pt, 'bo', 'MarkerSize', 1);

end
%filename = sprintf('TranscGIF/slide%d', k);
%print('-dpng', '-r0', filename);
end

%figure(2)
%plot(time_points, freq_points)