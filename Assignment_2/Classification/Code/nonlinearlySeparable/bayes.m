load_data;
figure;
scatter(train(:,1),train(:,2),[],target_train,'*');
a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Input data having 2 classes');

hold on;
figure;
scatter(train(:,1),train(:,2),'*');
hold on;
% Here 50 is the number of times the EM (GMM is fit) is run to make sure
% that correct result is obtained.

num1 = find_no_mixture_comps(class1_train,6,10); % Best is 3
gm_1 = fitgmdist(class1_train,num1);
ezcontour(@(x,y)pdf(gm_1,[x y]));
a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Gaussian contours of the GMM for class 1');
figure;
scatter(train(:,1),train(:,2),'*');
hold on;

num2 = find_no_mixture_comps(class2_train,10,10);
gm_2 = fitgmdist(class2_train,num2);
ezcontour(@(x,y)pdf(gm_2,[x y]),[-2 2]);
a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Gaussian contours of the GMM for class 2');
figure;
% Full plot
scatter(train(:,1),train(:,2),'*');
hold on;
ezcontour(@(x,y)pdf(gm_1,[x y]),[-2 2], [-2 2]);
hold on;
ezcontour(@(x,y)pdf(gm_2,[x y]),[-2 2],[-2 2]);



% Prediction of class label for new examples (test data)

% P(X|C_k) - likelihood
   
p_val = [pdf(gm_1,val), pdf(gm_2,val)];   

% argmax_i P(X|C_k)
[~,y_test]  = max(p_test,[],2);   
[~,y_val]  = max(p_val,[],2);   

% Here , C is confusion matrix
[C_test,order1] = confusionmat(target_test,y_test);
[C_val,order2] = confusionmat(target_val,y_val);



% Decision region.
xrange = [-2 2];
yrange = [-2 2];
inc = 0.01;
[x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2)); 
image_size = size(x); 
xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.
probs  = [pdf(gm_1,xy), pdf(gm_2,xy)];   
[~,idx]  = max(probs,[],2);                          

figure;
decisionmap = reshape(idx, image_size);
imagesc(xrange,yrange,decisionmap);
hold on;
set(gca,'ydir','normal');
cmap = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1; 0.6 0.7 1];
colormap(cmap);

plot(class1_train(:,1),class1_train(:,2),'r*');
plot(class2_train(:,1),class2_train(:,2),'b*');

a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Decision region plot');

