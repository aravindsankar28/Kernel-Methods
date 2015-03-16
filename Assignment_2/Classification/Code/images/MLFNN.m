load_data;
inputs = data';
targets = oneofk_target';

combined = [inputs;targets];
combined = combined(:,randperm(size(combined,2)));

inputs = combined(1:48,:);
targets = combined(49:53,:);
bestnet = patternnet([1,1]);
valerr = 1000;
% Create a Pattern Recognition Network
 for i= 10:11
 for j = 5:8
 net = patternnet([i,j]);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{3}.processFcns = {'removeconstantrows','mapminmax'};

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
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', 'plotconfusion'...
  'plotregression', 'plotfit'};
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'tansig';
net.layers{3}.transferFcn = 'tansig';
net.trainParam.epochs = 3000;

% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);
trainOut = outputs .* tr.trainMask{1};
testOut = outputs .* tr.testMask{1};
valOut = outputs .* tr.valMask{1};

%trainOut = trainOut(:,1:500);
%testOut = testOut(:,801:1000);
%valOut =  valOut(:,501:800);

% Recalculate Training, Validation and Test Performance
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs)
valPerformance = perform(net,valTargets,outputs)
testPerformance = perform(net,testTargets,outputs)
 
  if (valPerformance < valerr)
     bestnet = net;
     valerr = valPerformance;
  end
 end
 end
  view(bestnet)
  display(bestnet)
%  
% trainTargets  = trainTargets(:,1:500);
% testTargets  = testTargets(:,801:1000);
% valTargets  = valTargets(:,501:800);
% 
% traintarget = zeros(500,1);
% trainop = zeros(500,1);
% testtarget = zeros(200,1);
% testop = zeros(200,1);
% valtarget = zeros(300,1);
% valop = zeros(300,1);
% for k = 1:500
%     if (trainOut(1,k) >= trainOut(2,k) && trainOut(1,k) >= trainOut(3,k) && trainOut(1,k) >= trainOut(4,k))
%         trainop(k) = 1;
%     elseif (trainOut(2,k) >= trainOut(1,k) && trainOut(2,k) >= trainOut(3,k) && trainOut(2,k) >= trainOut(4,k))
%         trainop(k) = 2;
%     elseif (trainOut(3,k) >= trainOut(2,k) && trainOut(3,k) >= trainOut(1,k) && trainOut(3,k) >= trainOut(4,k))
%         trainop(k) = 3;
%     elseif (trainOut(4,k) >= trainOut(2,k) && trainOut(4,k) >= trainOut(1,k) && trainOut(4,k) >= trainOut(3,k))
%         trainop(k) = 4;
%     end
%     
%     if (trainTargets(1,k) >= trainTargets(2,k) && trainTargets(1,k) >= trainTargets(3,k) && trainTargets(1,k) >= trainTargets(4,k))
%         traintarget(k) = 1;
%     elseif (trainTargets(2,k) >= trainTargets(1,k) && trainTargets(2,k) >= trainTargets(3,k) && trainTargets(2,k) >= trainTargets(4,k))
%         traintarget(k) = 2;
%     elseif (trainTargets(3,k) >= trainTargets(2,k) && trainTargets(3,k) >= trainTargets(1,k) && trainTargets(3,k) >= trainTargets(4,k))
%         traintarget(k) = 3;
%     elseif (trainTargets(4,k) >= trainTargets(1,k) && trainTargets(4,k) >= trainTargets(2,k) && trainTargets(4,k) >= trainTargets(3,k))
%         traintarget(k) = 4;
%     end
% end
% 
% for k = 1:200
%     if (testOut(1,k) >= testOut(2,k) && testOut(1,k) >= testOut(3,k) && testOut(1,k) >= testOut(4,k))
%         testop(k) = 1;
%     elseif (testOut(2,k) >= testOut(1,k) && testOut(2,k) >= testOut(3,k) && testOut(2,k) >= testOut(4,k))
%         testop(k) = 2;
%     elseif (testOut(3,k) >= testOut(2,k) && testOut(3,k) >= testOut(1,k) && testOut(3,k) >= testOut(4,k))
%         testop(k) = 3;
%     elseif (testOut(4,k) >= testOut(1,k) && testOut(4,k) >= testOut(2,k) && testOut(4,k) >= testOut(3,k))
%         testop(k) = 4;
%     end
%     
%     if (testTargets(1,k) >= testTargets(2,k) && testTargets(1,k) >= testTargets(3,k) && testTargets(1,k) >= testTargets(4,k))
%         testtarget(k) = 1;
%     elseif (testTargets(2,k) >= testTargets(1,k) && testTargets(2,k) >= testTargets(3,k) && testTargets(2,k) >= testTargets(4,k))
%         testtarget(k) = 2;
%     elseif (testTargets(3,k) >= testTargets(2,k) && testTargets(3,k) >= testTargets(1,k) && testTargets(3,k) >= testTargets(4,k))
%         testtarget(k) = 3;
%     elseif (testTargets(4,k) >= testTargets(1,k) && testTargets(4,k) >= testTargets(2,k) && testTargets(4,k) >= testTargets(3,k))
%         testtarget(k) = 4;
%     end
% end
% 
% for k = 1:300
%     if (valOut(1,k) >= valOut(2,k) && valOut(1,k) >= valOut(3,k) && valOut(1,k) >= valOut(4,k))
%         valop(k) = 1;
%     elseif (valOut(2,k) >= valOut(1,k) && valOut(2,k) >= valOut(3,k) && valOut(2,k) >= valOut(4,k))
%         valop(k) = 2;
%     elseif (valOut(3,k) >= valOut(2,k) && valOut(3,k) >= valOut(1,k) && valOut(3,k) >= valOut(4,k))
%         valop(k) = 3;
%     elseif (valOut(4,k) >= valOut(1,k) && valOut(4,k) >= valOut(2,k) && valOut(4,k) >= valOut(3,k))
%         valop(k) = 4;
%     end
%     
%     if (valTargets(1,k) >= valTargets(2,k) && valTargets(1,k) >= valTargets(3,k) && valTargets(1,k) >= valTargets(4,k))
%         valtarget(k) = 1;
%     elseif (valTargets(2,k) >= valTargets(1,k) && valTargets(2,k) >= valTargets(3,k) && valTargets(2,k) >= valTargets(4,k))
%         valtarget(k) = 2;
%     elseif (valTargets(3,k) >= valTargets(2,k) && valTargets(3,k) >= valTargets(1,k) && valTargets(3,k) >= valTargets(4,k))
%         valtarget(k) = 3;
%     elseif (valOut(4,k) >= valOut(2,k) && valOut(4,k) >= valOut(1,k) && valOut(4,k) >= valOut(3,k))
%         valop(k) = 4;
%     end
% end
% % View the Network
% % view(net)
% % display(net)
% % Plots
% % Uncomment these lines to enable various plots.
% % figure, plotperform(tr)
% % figure, plottrainstate(tr)
% % figure, plotconfusion(targets,outputs)
% % figure, ploterrhist(errors)
% % end
% 
% %view(net)
% %display(net)
% % Plots
% % Uncomment these lines to enable various plots.
% %figure, plotperform(tr)
% %figure, plottrainstate(tr)
% %figure, plotconfusion(targets,outputs)
% %figure, ploterrhist(errors)
% 

% cm = confusionmat(traintarget, trainop);
% latex(sym(cm))
% c2m = confusionmat(testtarget, testop);
% latex(sym(c2m))
% c3m = confusionmat(valtarget, valop);
% latex(sym(c3m))
return
xrange = [-2 2];
yrange = [-2 2];
inc = 0.1;
[x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2)); 
image_size = size(x); 
xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.
outputs = net(xy');
outputs = outputs';
probs  = [outputs(:,1), outputs(:,2)];   
[~,idx]  = max(probs,[],2);                          

figure;
decisionmap = reshape(idx, image_size);
imagesc(xrange,yrange,decisionmap);
hold on;
set(gca,'ydir','normal');
cmap = [1 0.8 0.8; 0.95 1 0.95];
colormap(cmap);

targets = targets';
inputs = inputs';

inputs1 = zeros(1,2);
inputs2 = zeros(1,2);
for j = 1:1000
    if targets(j,1) == 1
        inputs1 = [inputs1; inputs(j,:)];
        
    end
    if targets(j,2) == 1
        inputs2 = [inputs2; inputs(j,:)];
        
    end

end
inputs1 = inputs1(2:size(inputs1,1),:);
inputs2 = inputs2(2:size(inputs2,1),:);

plot(inputs1(:,1),inputs1(:,2),'r*');
plot(inputs2(:,1),inputs2(:,2),'k*');

a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Decision region plot');


% 
% 