load_data;

inputs = data_input';
targets = data_target';

% Create a Pattern Recognition net
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.performFcn = 'mse';
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

% View the net
view(net)

