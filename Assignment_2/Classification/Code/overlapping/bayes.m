load_data;
%scatter(train(:,1),train(:,2),[], target_train);

scatter(train(:,1),train(:,2),'*');
hold on;
% Here 100 is the number of times the EM (GMM is fit) is run to make sure
% that correct result is obtained.

num1 = find_no_mixture_comps(class1_train,5,100); % Best is 1
gm_1 = fitgmdist(class1_train,num1);
ezcontour(@(x,y)pdf(gm_1,[x y]), [-6, 12],[-6, 12]);

hold on;

num2 = find_no_mixture_comps(class2_train,5,100);
gm_2 = fitgmdist(class2_train,num2);
ezcontour(@(x,y)pdf(gm_2,[x y]), [-6, 12],[-6, 12]);
% Still can't figure out optimal no. of components for class 2 .. the AIC
% criterion keeps decreasing. 
