load_data;
scatter(train_data(:,1),train_data(:,2),[], target_train,'*');
a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Input data having 4 classes');

figure,scatter(train_data(:,1),train_data(:,2),[],target_train,'*');
hold on;


% Here 100 is the number of times the EM (GMM is fit) is run to make sure
% that correct result is obtained.

num1 = find_no_mixture_comps(class1_train,5,10); % Best is 1
gm_1 = fitgmdist(class1_train,num1);
ezcontour(@(x,y)pdf(gm_1,[x y]), [-6, 12],[-6, 12]);

hold on;

num2 = find_no_mixture_comps(class2_train,5,10);
gm_2 = fitgmdist(class2_train,num2);
ezcontour(@(x,y)pdf(gm_2,[x y]), [-6, 12],[-6, 12]);

hold on;

num3 = find_no_mixture_comps(class3_train,5,10); % Best is 1
gm_3 = fitgmdist(class3_train,num3);
ezcontour(@(x,y)pdf(gm_3,[x y]), [-6, 12],[-6, 12]);

hold on;


num4 = find_no_mixture_comps(class4_train,5,10); % Best is 1
gm_4 = fitgmdist(class4_train,num4);
ezcontour(@(x,y)pdf(gm_4,[x y]), [-6, 12],[-6, 12]);

hold on;

a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Gaussian contours of all the classes');


% Prediction of class label for new examples (test data)

% P(X|C_k) - likelihood
p_test = [pdf(gm_1,test), pdf(gm_2,test), pdf(gm_3,test), pdf(gm_4,test)];   
p_val = [pdf(gm_1,val), pdf(gm_2,val), pdf(gm_3,val), pdf(gm_4,val)];   
p_train = [pdf(gm_1,train_data), pdf(gm_2,train_data),  pdf(gm_3,train_data),  pdf(gm_4,train_data)];   

% argmax_i P(X|C_k)
[~,y_test]  = max(p_test,[],2);   
[~,y_val]  = max(p_val,[],2);   
[~,y_train]  = max(p_train,[],2);   
% Here , C is confusion matrix

[C_test,order1] = confusionmat(target_test,y_test);
[C_val,order2] = confusionmat(target_val,y_val);
[C_train,order3] = confusionmat(target_train,y_train);


% Decision region.
xrange = [-6 12];
yrange = [-6 12];
inc = 0.01;
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
