function y = MLPEval(x, w1, w2, b1, b2)

[~,N] = size(x);

x1 = [b1*ones(1,N); x];
v1 = w1*x1;
%y1 = 1./(1+exp(-v1));
y1 = tanh(v1);

x2 = [b2*ones(1,N); y1];
v2 = w2*x2;
%y = 1./(1+exp(-v2));
y = tanh(v2);
