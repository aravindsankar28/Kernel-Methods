load_data;

inputs = data_input';
targets = data_target';
val_performances = ones(10,10)*10000;
train_performances = ones(10,10)*10000;
test_performances = ones(10,10)*10000;

for i = 1:8
    for j = 1:i
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
    % View the net
    %view(net);


    end
end

return;

% need to find the best performing one ...