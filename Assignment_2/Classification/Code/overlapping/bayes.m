load_data;
scatter(train(:,1),train(:,2),[], target_train,'*');
figure;
scatter(train(:,1),train(:,2),'*');
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

% Prediction of class label for new examples (test data)

% P(X|C_k) - likelihood
p_test = [pdf(gm_1,test), pdf(gm_2,test)];   
p_val = [pdf(gm_1,val), pdf(gm_2,val)];   

% argmax_i P(X|C_k)
[~,y_test]  = max(p_test,[],2);   
[~,y_val]  = max(p_val,[],2);   

% Here , C is confusion matrix
[C_test,order1] = confusionmat(target_test,y_test);
[C_val,order2] = confusionmat(target_test,y_test);



% Decision region.
xrange = [-6 12];
yrange = [-6 12];
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


xlabel('x');
ylabel('y');
