load_data;
figure;
scatter(train(:,1),train(:,2),[], target_train,'*');
a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Input data having 4 classes');

% Here it's obvious that numer of gaussians = 1 from scatter plot
%GMModels = cell(4,1);
options = statset('Display','final','MaxIter',2000);

gm_1 = fitgmdist(class1_train,1,'Options',options);
gm_2 = fitgmdist(class2_train,1,'Options',options);
gm_3 = fitgmdist(class3_train,1,'Options',options);
gm_4 = fitgmdist(class4_train,1,'Options',options);

% 
% GMModels{1} = fitgmdist(class1_train,1,'Options',options);
% GMModels{2} = fitgmdist(class2_train,1,'Options',options);
% GMModels{3} = fitgmdist(class3_train,1,'Options',options);
% GMModels{4} = fitgmdist(class4_train,1,'Options',options);




% Prediction of class label for new examples (test data)

% P(X|C_k) - likelihood
p_test = [pdf(gm_1,test), pdf(gm_2,test), pdf(gm_3,test), pdf(gm_4,test)];   
p_val = [pdf(gm_1,val), pdf(gm_2,val), pdf(gm_3,val), pdf(gm_4,val)];   
% argmax_i P(X|C_k)
[~,y_test]  = max(p_test,[],2);   
[~,y_val]  = max(p_val,[],2);   

% Plot the predicted class labels - not required.
%scatter(test(:,1),test(:,2),[], y_test);

% Here , C is confusion matrix
[C_test,order1] = confusionmat(target_test,y_test);
[C_val,order2] = confusionmat(target_val,y_val);

figure;

% Contour plots
scatter(train(:,1),train(:,2),'*');
hold on;
ezcontour(@(x,y)pdf(gm_1,[x y]),[min(train(:,1)) max(train(:,1))],[min(train(:,2)) max(train(:,2))]);
hold on;
ezcontour(@(x,y)pdf(gm_2,[x y]),[min(train(:,1)) max(train(:,1))],[min(train(:,2)) max(train(:,2))]);
hold on;
ezcontour(@(x,y)pdf(gm_3,[x y]),[min(train(:,1)) max(train(:,1))],[min(train(:,2)) max(train(:,2))]);
hold on;
ezcontour(@(x,y)pdf(gm_4,[x y]),[min(train(:,1)) max(train(:,1))],[min(train(:,2)) max(train(:,2))]);

a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');

title('Gaussian contours of the 4 class conditional distributions');


% Decision region.
xrange = [-16 20];
yrange = [-16 20];
inc = 0.1;
[x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2)); 
image_size = size(x); 
xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.
probs  = [pdf(gm_1,xy), pdf(gm_2,xy), pdf(gm_3,xy), pdf(gm_4,xy)];   
[~,idx]  = max(probs,[],2);                          

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