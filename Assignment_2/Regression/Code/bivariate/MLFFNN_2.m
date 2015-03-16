load_data;

inputs = data_input';
targets = data_target';
val_performances = ones(10,10)*10000;
train_performances = ones(10,10)*10000;
test_performances = ones(10,10)*10000;
a = zeros(100,5);
index = 1;

for i = 3:3
    for j = 2:2
        h1 = i*5;
        h2 = j*5;
        net = fitnet([h1,h2]);
        %net = fitnet(hiddenLayerSize);
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

        val_performances(i,j)= valPerformance; 
        train_performances(i,j) = trainPerformance;
        test_performances(i,j) = testPerformance;
        
        a(index,:) = [h1,h2,trainPerformance,valPerformance,testPerformance];
        index = index +1;
        
    % View the net
    %view(net);


    end
end

[minval,idx] = min(a(1:36,4));
a(idx,3)
a(idx,4)

%plot3(a(1:36,1),a(1:36,2),a(1:36,3),'r');

% 15.0000   10.0000 is the best.

% Plot of target & model outputs

%figure, plot3(inputs(1,:).* tr.trainMask{1}, inputs(2,:).* tr.trainMask{1}, trainTargets,'r*',inputs(1,:).* tr.trainMask{1}, inputs(2,:).* tr.trainMask{1},outputs.* tr.trainMask{1},'b*');
%title('Plot showing the model and target output (train set)');
%xlabel('x');
%ylabel('Target and Model output');
%legend('Target output','Model output');

%figure, plot3(inputs(1,:).* tr.valMask{1}, inputs(2,:).* tr.valMask{1}, valTargets,'r*',inputs(1,:).* tr.valMask{1}, inputs(2,:).* tr.valMask{1},outputs.* tr.valMask{1},'b*');
%title('Plot showing the model and target output (validation set)');
%xlabel('x');
%ylabel('Target and Model output');
%legend('Target output','Model output');

%figure, plot3(inputs(1,:).* tr.testMask{1}, inputs(2,:).* tr.testMask{1}, testTargets,'r*',inputs(1,:).* tr.testMask{1}, inputs(2,:).* tr.testMask{1},outputs.* tr.testMask{1},'b*');
%title('Plot showing the model and target output (test set)');
%xlabel('x');
%ylabel('Target and Model output');
%legend('Target output','Model output');




%figure, plot3(inputs(1,:)',inputs(2,:)',targets','r*',inputs(1,:)',inputs(2,:)',outputs','b*');
%legend('Target output','Model output');
%title('Plot showing target and model output');
%a = xlabel('$x_1$');
%b = ylabel('$x_2$');
%set(a,'Interpreter','latex');
%set(b,'Interpreter','latex');



% epochs = [1,2,5,15,1000];
% 
% for i = 1:length(epochs)
%     net = fitnet([15,10]);
% 	
%     net.trainFcn = 'trainlm';
%     net.divideFcn = 'divideblock';  % Divide blockwise
%     net.trainParam.epochs = epochs(i);
%     
%     net.divideParam.trainRatio = (2/3);
%     net.divideParam.valRatio = (1/6);
%     net.divideParam.testRatio = (1/6);
% 	[net,tr] = train(net,inputs,targets);
% 	outputs = net(inputs);
%     
% 	%figure,plot3(inputs(1,:)',inputs(2,:)',outputs','k*');
%     %legend(strcat('Epochs  ',int2str(epochs(i)))); a = xlabel('$x_1$'); b
%     %= ylabel('$x_2$'); set(a,'Interpreter','latex');
%     %set(b,'Interpreter','latex'); title(strcat('Approximated function at
%     %epoch =  ',int2str(epochs(i))));
% end


% To plot output at hidden nodes w.r.t epochs
layerNo = 2;
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
    figure,plot3(inputs(1,:)',inputs(2,:)',s(52,:)','*');
    %title(int2str(epochs(i)));
    
    
	%figure,plot3(inputs(1,:)',inputs(2,:)',outputs','k*');
    legend(int2str(epochs(i)));
    a = xlabel('$x_1$');
    b = ylabel('$x_2$');
    set(a,'Interpreter','latex');
    set(b,'Interpreter','latex');
    title(strcat('Hidden layer output at epoch =  ',int2str(epochs(i))));
end


return;

% need to find the best performing one ..

