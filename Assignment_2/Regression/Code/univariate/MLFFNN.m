load_data;

inputs = data_input';
targets = data_target';

val_performances = 1000*ones(100,1);
train_performances = 1000*ones(100,1);
test_performances = 1000*ones(100,1);
for i = 1:100

    hiddenLayerSize = i*2;
    net = fitnet(hiddenLayerSize);
    net.performFcn = 'mse';
    net.trainFcn = 'trainlm';
    %net.trainParam.epochs = 1000;
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


% Best num = 4

net = fitnet(num);
net.performFcn = 'mse';
net.trainFcn = 'trainlm';
net.trainParam.epochs = 1000;
net.trainParam.goal = 0.0001;
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};

net.divideFcn = 'divideblock';  % Divide blockwise
net.divideParam.trainRatio = (2/3);
net.divideParam.valRatio = (1/6);
net.divideParam.testRatio = (1/6);


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

models = (1:100)*2;
plot(models,train_performances,models,val_performances,models,test_performances);
xlabel('Model complexity (Nodes in hidden layer)');
ylabel('Performance (MSE)');
title('Plot showing variation of MSE for different model complexities');
% For scatter plot, check plotregression

% Plot(s) of model and target outputs
figure, plotfit(net,inputs,targets);

figure, plot(inputs, targets,'r*',inputs,outputs,'b*');
title('Plot showing the model and target output (all points)');
xlabel('x');
ylabel('Target and Model output');
legend('Target output','Model output');

% To plot output at hidden and output nodes w.r.t epochs
epochs = [1,2,4,8,1000];

legend_str = cell(5,1);
figure;
cc = hsv(5);

layerNo = 1;
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
	%plot(inputs,outputs,'*','color',cc(i,:)); 
    %hold on;
    
    legend_str{i} = strcat('Epoch  ',int2str(epochs(i)));
    
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
    figure,plot(inputs,s','*');
    title(int2str(epochs(i)));
    
    
end
%legend(legend_str);
% xlabel('x');
% ylabel('Model output');
% title('Output of output node as a fuction of Epochs');



