load_data;
scatter(train(:,1),train(:,2),'*');
hold on;
% Here 50 is the number of times the EM (GMM is fit) is run to make sure
% that correct result is obtained.

num1 = find_no_mixture_comps(class1_train,6,100); % Best is 3
gm_1 = fitgmdist(class1_train,num1);
ezcontour(@(x,y)pdf(gm_1,[x y]));

figure;
scatter(train(:,1),train(:,2),'*');
hold on;

num2 = find_no_mixture_comps(class2_train,10,100);
gm_2 = fitgmdist(class2_train,num2);
ezcontour(@(x,y)pdf(gm_2,[x y]),[-2 2]);

figure;
% Full plot
scatter(train(:,1),train(:,2),'*');
hold on;
ezcontour(@(x,y)pdf(gm_1,[x y]),[-2 2], [-2 2]);
hold on;
ezcontour(@(x,y)pdf(gm_2,[x y]),[-2 2],[-2 2]);


