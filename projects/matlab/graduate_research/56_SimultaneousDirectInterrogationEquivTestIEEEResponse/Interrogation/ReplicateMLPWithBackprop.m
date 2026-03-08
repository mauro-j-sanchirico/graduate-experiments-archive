function found_mlp_params = ...
    ReplicateMLPWithBackprop(x_stimulus, y_measured)

net = fitnet(5);
net.inputs{1}.processFcns={}; % off mapminmax
net.outputs{2}.processFcns={}; % off mapminmax
net.plotFcns = {};
net.trainParam.showWindow=0;

[net, ~] = train(net, x_stimulus, y_measured);

found_mlp_params.w_layer0 = net.IW{1};
found_mlp_params.b_layer0 = net.b{1};

found_mlp_params.w_layer1 = net.LW{2};
found_mlp_params.b_layer1 = net.b{2};

end

