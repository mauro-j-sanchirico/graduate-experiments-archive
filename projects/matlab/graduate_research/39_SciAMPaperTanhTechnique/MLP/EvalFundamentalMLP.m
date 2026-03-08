function y = EvalFundamentalMLP( ...
    w0_layer1, w1_layer1, w0_layer0, w1_layer0, x)

v = w0_layer0 + w1_layer0*x;
y = w0_layer1 + w1_layer1*tanh(v);

end
