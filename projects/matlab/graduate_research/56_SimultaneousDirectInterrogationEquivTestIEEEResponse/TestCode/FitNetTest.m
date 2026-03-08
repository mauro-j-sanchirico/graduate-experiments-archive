clc; clear; close all;

rng(0);

%%

rng(0);
[x,t] = simplefit_dataset;
net = fitnet(5);
net.inputs{1}.processFcns={}; % off mapminmax
net.outputs{2}.processFcns={}; % off mapminmax
net.plotFcns = {};
net.trainParam.showWindow=0;

%[x,ps] = mapminmax(x); 
%[t,pt] = mapminmax(t);
%net.divideFcn = 'divideind';   
%net.divideParam.trainInd = 1:60; 
%net.divideParam.valInd   = 61:94;
%net.divideParam.testInd  = 94; 
[net, tr] = train(net,x,t);
%y = net(mapminmax('apply',4,ps));
%y = mapminmax('reverse',y,pt) 

mlp_params.w_layer0 = net.IW{1};
mlp_params.b_layer0 = net.b{1};

mlp_params.w_layer1 = net.LW{2};
mlp_params.b_layer1 = net.b{2};


%%

psi = 0:0.001:1;
xtest1 = sin(2*pi*5*psi);
xtest2 = sin(2*pi*4*psi);
xtest = xtest2;

y_mlp = EvalInHouseMLP(xtest, psi, mlp_params);
y_fitnet = net(xtest);

figure;
plot(psi, y_mlp, 'linewidth', 6, 'color', 'b');
hold on;
plot(psi, y_fitnet, 'linewidth', 2, 'color', 'g');


function y = EvalInHouseMLP(x, t, mlp_params)

%[x,ps] = mapminmax(x); 
%[t,pt] = mapminmax(t);

y = EvalMLP(mlp_params, x);

end
