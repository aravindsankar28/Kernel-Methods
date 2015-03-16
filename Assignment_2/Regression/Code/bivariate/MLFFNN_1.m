load_data;

inputs = data_input';
targets = data_target';
val_performances = ones(100,1)*10000;
train_performances = ones(100,1)*10000;
test_performances = ones(100,1)*10000;
for i = 2:10

    hiddenLayerSize = i*2;
    net = fitnet(hiddenLayerSize);
    net.performFcn = 'mse';
    net.trainFcn = 'trainlm';
    net.trainParam.epochs = 1000;
    %net.trainParam.goal = 0.009;
    net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
      'plotregression', 'plotfit'};

    net.divideFcn = 'divideblock';  % Divide blockwise
    net.divideParam.trainRatio = (2/3);
    net.divideParam.valRatio = (1/6);
    net.divideParam.testRatio = (1/6);


    % Train the net
    [net,tr] = train(net,inputs,targets);

    % Test the net
    outputs = net(inputs);
    errors = gsubtract(outputs,targets);
    performance = perform(net,targets,outputs);
    trainTargets = targets .* tr.trainMask{1};
    valTargets = targets  .* tr.valMask{1};
    testTargets = targets  .* tr.testMask{1};
    trainPerformance = perform(net,trainTargets,outputs);
    valPerformance = perform(net,valTargets,outputs);
    testPerformance = perform(net,testTargets,outputs);

    val_performances(i)= valPerformance; 
    train_performances(i) = trainPerformance;
    test_performances(i) = testPerformance;
% View the net
%view(net);


end

[~,idx] = min(val_performances);

num = idx*2;
num

net = fitnet(num);
net.performFcn = 'mse';
net.trainFcn = 'trainlm';
net.trainParam.epochs = 3000;
net.trainParam.goal = 0.0001;

[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs);
valPerformance = perform(net,valTargets,outputs);
testPerformance = perform(net,testTargets,outputs);

models = (2:100)*2;
plot(models,train_performances(2:100),models,val_performances(2:100),models,test_performances(2:100));

xlabel('Model complexity (No. of hidden nodes)');
ylabel('Performance (MSE)');
legend('Train','Validation','Test');
%plot(models,train_performances,models,val_performances,models,test_performances);

% For scatter plot, check plotregression

figure, plot3(inputs(1,:)',inputs(2,:)',targets','r*',inputs(1,:)',inputs(2,:)',outputs','b*');
legend('Target output','Model output');
title('Plot showing target and model output');
a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');


% To plot output at hidden and output nodes w.r.t epochs
layerNo = 1;
epochs = [1,2,5,15,1000];

for i = 1:length(epochs)
    net = fitnet(num);
	
    net.trainFcn = 'trainlm';
    net.divideFcn = 'divideblock';  % Divide blockwise
    net.trainParam.epochs = epochs(i);
    
    net.divideParam.trainRatio = (2/3);
    net.divideParam.valRatio = (1/6);
    net.divideParam.testRatio = (1/6);
	[net,tr] = train(net,inputs,targets);
	outputs = net(inputs);
    
    
    
    a1 = bsxfun(@plus, net.iw{1}*inputs, net.b{1});
    actFcn1 = str2func(net.layers{1}.transferFcn);
    actFcnParams1 = net.layers{1}.transferParam;
    s1 = actFcn1(a1,actFcnParams1);
   
    s = s1;
    if (layerNo > 1)
        for lIndex = 2 : layerNo
            a = net.lw{lIndex, lIndex-1}*s;
            if (net.biasConnect(lIndex))
                a = bsxfun(@plus, a, net.b{lIndex});
            end
            actFcn = str2func(net.layers{lIndex}.transferFcn);
            actFncParams = net.layers{lIndex}.transferParam;
            s = actFcn(a, actFncParams);
        end
    end
    figure,plot3(inputs(1,:)',inputs(2,:)',s(5,:)','*');
    title(int2str(epochs(i)));
    
    
	%figure,plot3(inputs(1,:)',inputs(2,:)',outputs','k*');
    %legend(int2str(epochs(i)));
    a = xlabel('$x_1$');
    b = ylabel('$x_2$');
    set(a,'Interpreter','latex');
    set(b,'Interpreter','latex');title(strcat('Hidden layer output at epoch =  ',int2str(epochs(i))));
end
