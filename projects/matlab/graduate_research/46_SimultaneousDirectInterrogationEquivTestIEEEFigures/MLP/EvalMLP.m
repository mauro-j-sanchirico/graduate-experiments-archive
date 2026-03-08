function y = EvalMLP(params, x)

v = params.w_layer0*x + params.b_layer0;
y = params.w_layer1*tanh(v) + params.b_layer1;

end
