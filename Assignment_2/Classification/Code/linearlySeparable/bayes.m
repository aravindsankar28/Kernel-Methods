load_data;

scatter(train(:,1),train(:,2),[], target_train);
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
p = [pdf(gm_1,test), pdf(gm_2,test), pdf(gm_3,test), pdf(gm_4,test)];   

% argmax_i P(X|C_k)
[~,y_test]  = max(p,[],2);                          

% Plot the predicted class labels 
scatter(test(:,1),test(:,2),[], y_test);

% Here , C is confusion matrix
[C,order] = confusionmat(target_test,y_test);

figure;

% See of this is fine for decision region 
scatter(train(:,1),train(:,2));
hold on;
ezcontour(@(x,y)pdf(gm_1,[x y]),[min(train(:,1)) max(train(:,1))],[min(train(:,2)) max(train(:,2))]);
hold on;
ezcontour(@(x,y)pdf(gm_2,[x y]),[min(train(:,1)) max(train(:,1))],[min(train(:,2)) max(train(:,2))]);
hold on;
ezcontour(@(x,y)pdf(gm_3,[x y]),[min(train(:,1)) max(train(:,1))],[min(train(:,2)) max(train(:,2))]);
hold on;
ezcontour(@(x,y)pdf(gm_4,[x y]),[min(train(:,1)) max(train(:,1))],[min(train(:,2)) max(train(:,2))]);



xrange = [-16 20];
yrange = [-16 20];
inc = 0.1;

[x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2));
 
image_size = size(x); 
xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.
%xy2 = [reshape(x, image_size(1)*image_size(2),1) reshape(y, image_size(1)*image_size(2),1)];

probs  = [pdf(gm_1,xy), pdf(gm_2,xy), pdf(gm_3,xy), pdf(gm_4,xy)];   
[~,idx]  = max(probs,[],2);                          

figure;
decisionmap = reshape(idx, image_size);
imagesc(xrange,yrange,decisionmap);
hold on;
set(gca,'ydir','normal');
cmap = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1; 0.6 0.7 1];
%cmap = hsv(4);
colormap(cmap);

plot(class1_train(:,1),class1_train(:,2),'r*');
plot(class2_train(:,1),class2_train(:,2),'g*');
plot(class3_train(:,1),class3_train(:,2),'b*');
plot(class4_train(:,1),class4_train(:,2),'k*');

xlabel('x');
ylabel('y');