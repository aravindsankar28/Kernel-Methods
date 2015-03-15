load_data;

inputs = data_input';
targets = data_target(:,4)';

input_sets = cell(6);
target_sets = cell(6);
nets = cell(6);
input_sets{1}  = [class1_train; class2_train; class1_val; class2_val; class1_test;   class2_test ];
input_sets{2}  = [class1_train; class3_train; class1_val; class3_val; class1_test;   class3_test ];
input_sets{3}  = [class1_train; class4_train;  class1_val; class4_val; class1_test;   class4_test ];
input_sets{4}  = [class2_train; class3_train; class2_val; class3_val; class2_test;   class3_test ];
input_sets{5}  = [class2_train; class4_train; class2_val; class4_val;  class2_test;   class4_test ];
input_sets{6}  = [class3_train; class4_train; class3_val; class4_val; class3_test;   class4_test ];

target_sets{1}  = [ones(250,1); zeros(250,1); ones(150,1); zeros(150,1); ones(100,1); zeros(100,1) ];
target_sets{2}  = [ones(250,1); zeros(250,1); ones(150,1); zeros(150,1); ones(100,1); zeros(100,1) ];
target_sets{3}  = [ones(250,1); zeros(250,1); ones(150,1); zeros(150,1); ones(100,1); zeros(100,1) ];
target_sets{4}  = [ones(250,1); zeros(250,1); ones(150,1); zeros(150,1); ones(100,1); zeros(100,1) ];
target_sets{5}  = [ones(250,1); zeros(250,1); ones(150,1); zeros(150,1); ones(100,1); zeros(100,1) ];
target_sets{6}  = [ones(250,1); zeros(250,1); ones(150,1); zeros(150,1); ones(100,1); zeros(100,1) ];
output_values = cell(6);

for i = 1:6
    
    net = perceptron;
    net.divideFcn = 'divideblock';  % Divide blockwise
    net.divideParam.trainRatio = 0.5;
    net.divideParam.valRatio = 0.3;
    net.divideParam.testRatio = 0.2;
    
    % For help on training function 'trainlm' type: help trainlm
    % For a list of all training functions type: help nntrain
    net.trainFcn = 'trainc';
    net.performFcn = 'mse';  % Mean squared error
    net.trainParam.epochs = 2000;
    net.plotFcns = {'plotperform','plottrainstate','ploterrhist', 'plotconfusion',...
      'plotregression', 'plotfit'};
    inputs = input_sets{i}';
    targets = target_sets{i}';
    scatter(input_sets{i}(:,1),input_sets{i}(:,2),[],targets');
    [net,tr] = train(net,inputs,targets);
    
    outputs = net(inputs)';
    nets{i} = net;
    errors = gsubtract(targets,outputs);
    performance = perform(net,targets,outputs);

    % Recalculate Training, Validation and Test Performance
    trainTargets = targets .* tr.trainMask{1};
    valTargets = targets  .* tr.valMask{1};
    testTargets = targets  .* tr.testMask{1};
    trainPerformance = perform(net,trainTargets,outputs);
    valPerformance = perform(net,valTargets,outputs);
    testPerformance = perform(net,testTargets,outputs);

end

% View the network
%view(net)

% Plots
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotconfusion(targets,outputs)
% figure, ploterrhist(errors)
% 
% train_out = predictPerceptron(nets,train_data,1000);
% test_out = predictPerceptron(nets,test,400);
% val_out = predictPerceptron(nets,val,600);
% 

% Decision region plot.

xrange = [-16 20];
yrange = [-16 20];
inc = 0.1;
[x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2)); 
image_size = size(x); 
xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.

idx = predictPerceptron(nets,xy,length(xy));
figure;
decisionmap = reshape(idx, image_size);
imagesc(xrange,yrange,decisionmap);
hold on;
set(gca,'ydir','normal');
cmap = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1; 0.6 0.7 1];
colormap(cmap);

plot(class1_train(:,1),class1_train(:,2),'r*');
plot(class2_train(:,1),class2_train(:,2),'g*');
plot(class3_train(:,1),class3_train(:,2),'b*');
plot(class4_train(:,1),class4_train(:,2),'k*');

a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Decision region plot');