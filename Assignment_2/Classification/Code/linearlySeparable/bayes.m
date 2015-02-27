load_data;

scatter(train(:,1),train(:,2),[], target_train);
% Here it's obvious that numer of gaussians = 1 from scatter plot

options = statset('Display','final','MaxIter',1500);
gm_1 = fitgmdist(class1_train,1,'Options',options);
gm_2 = fitgmdist(class2_train,1,'Options',options);
gm_3 = fitgmdist(class3_train,1,'Options',options);
gm_4 = fitgmdist(class4_train,1,'Options',options);

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

