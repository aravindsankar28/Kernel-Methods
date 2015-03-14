load_data;

inputs = data_input';
targets = data_target';

val_performances = zeros(20,1);

for i = 1:40

    hiddenLayerSize = i*5;
    net = fitnet(hiddenLayerSize);
    net.performFcn = 'mse';
    net.trainFcn = 'trainlm';
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
    
    valTargets = targets  .* tr.valMask{1};
    valPerformance = perform(net,valTargets,outputs);

    val_performances(i)= valPerformance; 
% View the net
%view(net);


end

[~,idx] = min(val_performances);

idx*5


