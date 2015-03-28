load data.mat;

inputs = data_input';
targets = data_target';
net = patternnet(16);
valerr = 1;
% Create a Pattern Recognition Network
% for i=1:30
 %hiddenLayerSize = i;
 %net = patternnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'divideblock';  % Divide blockwise
net.divideParam.trainRatio = 0.5;
net.divideParam.valRatio = 0.3;
net.divideParam.testRatio = 0.2;

% For help on training function 'trainlm' type: help trainlm
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainlm';  % Levenberg-Marquardt optimization, fastest backpropagation algorithm in the toolbox

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean squared error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};
net.layers{2}.transferFcn = 'tansig';
% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

trainOut = outputs .* tr.trainMask{1};
testOut = outputs .* tr.testMask{1};
valOut = outputs .* tr.valMask{1};

trainOut = trainOut(:,1:1000);
testOut = testOut(:,1601:2000);
valOut =  valOut(:,1001:1600);

% Recalculate Training, Validation and Test Performance
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs);
valPerformance = perform(net,valTargets,outputs);
testPerformance = perform(net,testTargets,outputs);
 
%  if (valPerformance < valerr)
%     bestnet = net;
%     valerr = valPerformance;
%  end
%  end
%  view(bestnet)
%  display(bestnet)
%  
trainTargets  = trainTargets(:,1:1000);
testTargets  = testTargets(:,1601:2000);
valTargets  = valTargets(:,1001:1600);

traintarget = zeros(1000,1);
trainop = zeros(1000,1);
testtarget = zeros(400,1);
testop = zeros(400,1);
valtarget = zeros(600,1);
valop = zeros(600,1);
for k = 1:1000
    if (trainOut(1,k) >= trainOut(2,k) && trainOut(1,k) >= trainOut(3,k) && trainOut(1,k) >= trainOut(4,k))
        trainop(k) = 1;
    elseif (trainOut(2,k) >= trainOut(1,k) && trainOut(2,k) >= trainOut(3,k) && trainOut(2,k) >= trainOut(4,k))
        trainop(k) = 2;
    elseif (trainOut(3,k) >= trainOut(2,k) && trainOut(3,k) >= trainOut(1,k) && trainOut(3,k) >= trainOut(4,k))
        trainop(k) = 3;
    elseif (trainOut(4,k) >= trainOut(2,k) && trainOut(4,k) >= trainOut(1,k) && trainOut(4,k) >= trainOut(3,k))
        trainop(k) = 4;
    end
    
    if (trainTargets(1,k) >= trainTargets(2,k) && trainTargets(1,k) >= trainTargets(3,k) && trainTargets(1,k) >= trainTargets(4,k))
        traintarget(k) = 1;
    elseif (trainTargets(2,k) >= trainTargets(1,k) && trainTargets(2,k) >= trainTargets(3,k) && trainTargets(2,k) >= trainTargets(4,k))
        traintarget(k) = 2;
    elseif (trainTargets(3,k) >= trainTargets(2,k) && trainTargets(3,k) >= trainTargets(1,k) && trainTargets(3,k) >= trainTargets(4,k))
        traintarget(k) = 3;
    elseif (trainTargets(4,k) >= trainTargets(1,k) && trainTargets(4,k) >= trainTargets(2,k) && trainTargets(4,k) >= trainTargets(3,k))
        traintarget(k) = 4;
    end
end

for k = 1:400
    if (testOut(1,k) >= testOut(2,k) && testOut(1,k) >= testOut(3,k) && testOut(1,k) >= testOut(4,k))
        testop(k) = 1;
    elseif (testOut(2,k) >= testOut(1,k) && testOut(2,k) >= testOut(3,k) && testOut(2,k) >= testOut(4,k))
        testop(k) = 2;
    elseif (testOut(3,k) >= testOut(2,k) && testOut(3,k) >= testOut(1,k) && testOut(3,k) >= testOut(4,k))
        testop(k) = 3;
    elseif (testOut(4,k) >= testOut(1,k) && testOut(4,k) >= testOut(2,k) && testOut(4,k) >= testOut(3,k))
        testop(k) = 4;
    end
    
    if (testTargets(1,k) >= testTargets(2,k) && testTargets(1,k) >= testTargets(3,k) && testTargets(1,k) >= testTargets(4,k))
        testtarget(k) = 1;
    elseif (testTargets(2,k) >= testTargets(1,k) && testTargets(2,k) >= testTargets(3,k) && testTargets(2,k) >= testTargets(4,k))
        testtarget(k) = 2;
    elseif (testTargets(3,k) >= testTargets(2,k) && testTargets(3,k) >= testTargets(1,k) && testTargets(3,k) >= testTargets(4,k))
        testtarget(k) = 3;
    elseif (testTargets(4,k) >= testTargets(1,k) && testTargets(4,k) >= testTargets(2,k) && testTargets(4,k) >= testTargets(3,k))
        testtarget(k) = 4;
    end
end

for k = 1:600
    if (valOut(1,k) >= valOut(2,k) && valOut(1,k) >= valOut(3,k) && valOut(1,k) >= valOut(4,k))
        valop(k) = 1;
    elseif (valOut(2,k) >= valOut(1,k) && valOut(2,k) >= valOut(3,k) && valOut(2,k) >= valOut(4,k))
        valop(k) = 2;
    elseif (valOut(3,k) >= valOut(2,k) && valOut(3,k) >= valOut(1,k) && valOut(3,k) >= valOut(4,k))
        valop(k) = 3;
    elseif (valOut(4,k) >= valOut(1,k) && valOut(4,k) >= valOut(2,k) && valOut(4,k) >= valOut(3,k))
        valop(k) = 4;
    end
    
    if (valTargets(1,k) >= valTargets(2,k) && valTargets(1,k) >= valTargets(3,k) && valTargets(1,k) >= valTargets(4,k))
        valtarget(k) = 1;
    elseif (valTargets(2,k) >= valTargets(1,k) && valTargets(2,k) >= valTargets(3,k) && valTargets(2,k) >= valTargets(4,k))
        valtarget(k) = 2;
    elseif (valTargets(3,k) >= valTargets(2,k) && valTargets(3,k) >= valTargets(1,k) && valTargets(3,k) >= valTargets(4,k))
        valtarget(k) = 3;
    elseif (valOut(4,k) >= valOut(2,k) && valOut(4,k) >= valOut(1,k) && valOut(4,k) >= valOut(3,k))
        valop(k) = 4;
    end
end
% View the Network
% view(net)
% display(net)
% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotconfusion(targets,outputs)
% figure, ploterrhist(errors)
% end

%view(net)
%display(net)
% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, plotconfusion(targets,outputs)
%figure, ploterrhist(errors)

% Decision region.
xrange = [-8 12];
yrange = [-8 12];
inc = 0.1;
[x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2)); 
image_size = size(x); 
xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.
outputs = net(xy');
outputs = outputs';
probs  = [outputs(:,1), outputs(:,2), outputs(:,3), outputs(:,4)];   
[~,idx]  = max(probs,[],2);                          

figure;
decisionmap = reshape(idx, image_size);
imagesc(xrange,yrange,decisionmap);
hold on;
set(gca,'ydir','normal');
cmap = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1; 0.6 0.7 1];
colormap(cmap);

targets = targets';
inputs = inputs';

inputs1 = zeros(1,2);
inputs2 = zeros(1,2);
inputs3 = zeros(1,2);
inputs4 = zeros(1,2);
for j = 1:2000
    if targets(j,1) == 1
        inputs1 = [inputs1; inputs(j,:)];
        
    end
    if targets(j,2) == 1
        inputs2 = [inputs2; inputs(j,:)];
        
    end
    if targets(j,3) == 1
        inputs3 = [inputs3; inputs(j,:)];
        
    end
    if targets(j,4) == 1
        inputs4 = [inputs4; inputs(j,:)];
       
    end
end
inputs1 = inputs1(2:size(inputs1,1),:);
inputs2 = inputs2(2:size(inputs2,1),:);
inputs3 = inputs3(2:size(inputs3,1),:);
inputs4 = inputs4(2:size(inputs4,1),:);
plot(inputs1(:,1),inputs1(:,2),'r*');
plot(inputs2(:,1),inputs2(:,2),'g*');
plot(inputs3(:,1),inputs3(:,2),'k*');
plot(inputs4(:,1),inputs4(:,2),'b*');
a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Decision region plot');

cm = confusionmat(traintarget, trainop);
latex(sym(cm))
c2m = confusionmat(testtarget, testop);
latex(sym(c2m))
c3m = confusionmat(valtarget, valop);
latex(sym(c3m))


% To plot output at hidden and output nodes w.r.t epochs


%EPOCH WISE----------------

epochs = [1,5,20];

for i = 1:length(epochs)
    inputs = data_input';
    targets = data_target';
    hiddenLayerSize = 16;
    net = patternnet(16);
    % Create a Pattern Recognition Network
    % for i=1:20
    % hiddenLayerSize = i;
    % net = patternnet(hiddenLayerSize);

    % Choose Input and Output Pre/Post-Processing Functions
    % For a list of all processing functions type: help nnprocess
    net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
    net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};
    
    % Setup Division of Data for Training, Validation, Testing
    % For a list of all data division functions type: help nndivide
    net.divideFcn = 'divideblock';  % Divide blockwise
    net.divideParam.trainRatio = 0.5;
    net.divideParam.valRatio = 0.3;
    net.divideParam.testRatio = 0.2;

    % For help on training function 'trainlm' type: help trainlm
    % For a list of all training functions type: help nntrain
    net.trainFcn = 'trainlm';  % Levenberg-Marquardt optimization, fastest backpropagation algorithm in the toolbox

    % Choose a Performance Function
    % For a list of all performance functions type: help nnperformance
    net.performFcn = 'mse';  % Mean squared error

    % Choose Plot Functions
    % For a list of all plot functions type: help nnplot
    net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
      'plotregression', 'plotfit'};
    net.layers{2}.transferFcn = 'tansig';
    net.trainParam.epochs = epochs(i);
    % Train the Network
    [net,tr] = train(net,inputs,targets);

    % Test the Network
    
    
    xrange = [-8 12];
    yrange = [-8 12];
    inc = 0.1;
    [x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2)); 
    xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.
    inputs = xy';


    outputs = net(inputs);
    outputs = outputs';
%  
%     f = figure, h=surf(x,y,reshape(outputs(:,1),size(x)));
%     set(h, 'edgecolor','none');
%     a = xlabel('$x_1$');
%     b = ylabel('$x_2$');
%     zlabel('output for class 1');
%     set(a,'Interpreter','latex');
%     set(b,'Interpreter','latex');title(strcat('output layer at epoch = ',int2str(epochs(i)),' for class 1'));
%     saveas(f,strcat('NewImages/',int2str(epochs(i)),'_1'),'png');
%     
%     
%     
%     f = figure, h=surf(x,y,reshape(outputs(:,2),size(x)));
%     set(h, 'edgecolor','none');
%     a = xlabel('$x_1$');
%     b = ylabel('$x_2$');
%     zlabel('output for class 2');
%     set(a,'Interpreter','latex');
%     set(b,'Interpreter','latex');title(strcat('output layer at epoch = ',int2str(epochs(i)), ' for class 2'));
%     %saveas(gcf,strcat(int2str(epochs(i)),'_2.png'));
%     saveas(f,strcat('NewImages/',int2str(epochs(i)),'_2'),'png');
%     
%     
%     f = figure, h=surf(x,y,reshape(outputs(:,3),size(x)));    	
%     set(h, 'edgecolor','none');
%     %figure,plot3(inputs(1,:)',inputs(2,:)',outputs(:,3),'b*');
%     a = xlabel('$x_1$');
%     b = ylabel('$x_2$');
%     zlabel('output for class 3');
%     set(a,'Interpreter','latex');
%     set(b,'Interpreter','latex');title(strcat('output layer at epoch = ',int2str(epochs(i)), ' for class 3'));
%     %saveas(gcf,strcat(int2str(epochs(i)),'_3.png'));
%     saveas(f,strcat('NewImages/',int2str(epochs(i)),'_3'),'png');
%     
%     
%     %figure,plot3(inputs(1,:)',inputs(2,:)',outputs(:,4),'k*'); 
%     f = figure, h=surf(x,y,reshape(outputs(:,4),size(x)));
%     set(h, 'edgecolor','none');
%     a = xlabel('$x_1$');
%     b = ylabel('$x_2$');
%     
%     zlabel('output for class 4');
%     set(a,'Interpreter','latex');
%     set(b,'Interpreter','latex');title(strcat('output layer at epoch =  ',int2str(epochs(i)), ' for class 4'));
%     a = xlabel('$x_1$');
%     b = ylabel('$x_2$');
%     saveas(f,strcat('NewImages/',int2str(epochs(i)),'_4'),'png');
%     

    
%     
%     a1 = bsxfun(@plus, net.iw{1}*inputs, net.b{1});
%     actFcn1 = str2func(net.layers{1}.transferFcn);
%     actFcnParams1 = net.layers{1}.transferParam;
%     s1 = actFcn1(a1,actFcnParams1);
%     layerNo = 1;
%     s = s1;
%     if (layerNo > 1)
%         for lIndex = 2 : layerNo
%             a = net.lw{lIndex, lIndex-1}*s;
%             if (net.biasConnect(lIndex))
%                 a = bsxfun(@plus, a, net.b{lIndex});
%             end
%             actFcn = str2func(net.layers{lIndex}.transferFcn);
%             actFncParams = net.layers{lIndex}.transferParam;
%             s = actFcn(a, actFncParams);
%         end
%     end
%     
%     
%     %figure,plot3(inputs(1,:)',inputs(2,:)',s(1,:),'k*');
%     
%     f = figure, h=surf(x,y,reshape(s(1,:),size(x)));
%     set(h, 'edgecolor','none');
%     a = xlabel('$x_1$');
%     b = ylabel('$x_2$');
%     zlabel('Hidden layer output for node 1');
%     set(a,'Interpreter','latex');
%     set(b,'Interpreter','latex');title(strcat('hidden layer at epoch = ',int2str(epochs(i)),' for node 1'));
%     %saveas(gcf,strcat('h',int2str(epochs(i)),'_1.png'));
%     saveas(f,strcat('NewImages/h',int2str(epochs(i)),'_1'),'png');
%     
%     %saveas(gcf,'Plots_1/RMS/RMS_complexity_20.png');
%     
%     %figure,plot3(inputs(1,:)',inputs(2,:)',s(5,:),'k*');
%     f = figure, h=surf(x,y,reshape(s(5,:),size(x)));
%     set(h, 'edgecolor','none');
%     a = xlabel('$x_1$');
%     b = ylabel('$x_2$');
%     zlabel('Hidden layer output for node 5');
%     set(a,'Interpreter','latex');
%     set(b,'Interpreter','latex');title(strcat('hidden layer at epoch = ',int2str(epochs(i)), ' for node 5'));
%     %saveas(gcf,strcat('h',int2str(epochs(i)),'_5.png'));
%     saveas(f,strcat('NewImages/h',int2str(epochs(i)),'_5'),'png');
%     
%     %figure,plot3(inputs(1,:)',inputs(2,:)',s(9,:),'k*');
%     f = figure, h=surf(x,y,reshape(s(9,:),size(x)));
%     set(h, 'edgecolor','none');
%     a = xlabel('$x_1$');
%     b = ylabel('$x_2$');
%     zlabel('Hidden layer output for node 9');
%     set(a,'Interpreter','latex');
%     set(b,'Interpreter','latex');title(strcat('hidden layer at epoch = ',int2str(epochs(i)), ' for node 9'));
%     saveas(f,strcat('NewImages/h',int2str(epochs(i)),'_9'),'png');
%     %saveas(gcf,strcat('h',int2str(epochs(i)),'_9.png'));
%     
%     
%     
%     %figure,plot3(inputs(1,:)',inputs(2,:)',s(15,:),'k*'); 
%     f = figure, h=surf(x,y,reshape(s(16,:),size(x)));
%     set(h, 'edgecolor','none');
% 
%     a = xlabel('$x_1$');
%     b = ylabel('$x_2$');
%     
%     zlabel('Hidden layer output for node 16');
%     set(a,'Interpreter','latex');
%     set(b,'Interpreter','latex');title(strcat('hidden layer at epoch =  ',int2str(epochs(i)), ' for node 16'));
%     a = xlabel('$x_1$');
%     b = ylabel('$x_2$');
%     saveas(f,strcat('NewImages/h',int2str(epochs(i)),'_16'),'png');
%     %saveas(gcf,strcat('h',int2str(epochs(i)),'_15.png'));
% 
%     
%     
% 


end
