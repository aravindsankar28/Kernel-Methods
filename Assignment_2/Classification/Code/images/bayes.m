load_data;

options = statset('Display','final','MaxIter',1500);

num1 = find_no_mixture_comps(class1_data,25,100); 
gm_1 = fitgmdist(class1_data,num1,'Regularize',0.1,'CovType','diagonal');
num1


return;
num2 = find_no_mixture_comps(class2_data,25,100); 
gm_2 = fitgmdist(class2_data,num2,'Regularize',0.1,'CovType','diagonal');
num2


num3 = find_no_mixture_comps(class3_data,25,100); 
gm_3 = fitgmdist(class3_data,num3,'Regularize',0.1,'CovType','diagonal');
num3


num4 = find_no_mixture_comps(class4_data,25,100); 
gm_4 = fitgmdist(class4_data,num4,'Regularize',0.1,'CovType','diagonal');
num4



num5 = find_no_mixture_comps(class5_data,25,100); 
gm_5 = fitgmdist(class5_data,num5,'Regularize',0.1,'CovType','diagonal');
num5

%ezcontour(@(x,y)pdf(gm_1,[x y]));

