clear; clc; close all;

% For any value of A between 1 and 2, besides 1, the waves will 
% always be fighting 50% of one period of y1 + y2

% This does not hold true for A > 2
n=1;
for A = 1:0.001:2

[N D] = rat(A);

tmin=0;
tmax=D*2*pi;
dt=0.01;

t=tmin:dt:tmax;

y0 = sin(t);
y1 = sin(A.*t);

y = [y0' y1'];

%figure(1)
%plot(t,y);
%ylim([-2 2]);

diffs = (sign(y(:,1)) - sign(y(:,2)));

sigma = sum(diffs(:)==0); % Number of elements that were the same sign

%sz = (length(t)-sum)/length(t) % percent els that were diff sign

%disp(sz);
x(n) = length(t) - sigma;
%disp(length(t)-sigma);

n=n+1;
end

semilogy(x);
xlims = xlim;
xlim([0 floor(length(x)+0.2*length(x))]);

%semilog plot has all the right minimums but not the right maximums