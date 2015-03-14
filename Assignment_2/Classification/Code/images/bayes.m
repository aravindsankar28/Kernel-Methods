load_data;

class1_train = class1_data(1:114,:);
class1_val = class1_data(115:153,:);
class1_test = class1_data(154:190,:);

class2_train = class2_data(1:88,:);
class2_val = class2_data(89:117,:);
class2_test = class2_data(118:147,:);


class3_train = class3_data(1:142,:);
class3_val = class3_data(143:190,:);
class3_test = class3_data(191:238,:);


class4_train = class4_data(1:114,:);
class4_val = class4_data(115:153,:);
class4_test = class4_data(154:190,:);

class5_train = class5_data(1:261,:);
class5_val = class5_data(262:348,:);
class5_test = class5_data(349:435,:);


target_train = [ones(size(class1_train,1),1); ones(length(class2_train),1)*2; ones(size(class3_train,1),1)*3; ones(size(class4_train,1),1)*4; ones(size(class5_train,1),1)*5];
target_val = [ones(size(class1_val,1),1); ones(size(class2_val,1),1)*2; ones(size(class3_val,1),1)*3; ones(size(class4_val,1),1)*4; ones(size(class5_val,1),1)*5];
target_test = [ones(size(class1_test,1),1); ones(size(class2_test,1),1)*2; ones(size(class3_test,1),1)*3; ones(size(class4_test,1),1)*4; ones(size(class5_test,1),1)*5];

train = [class1_train; class2_train; class3_train; class4_train ; class5_train ];
val = [class1_val; class2_val; class3_val; class4_val ; class5_val ];
test = [class1_test; class2_test; class3_test; class4_test ; class5_test];

misclass_rates_train = zeros(30,1);

misclass_rates_val = zeros(30,1);

misclass_rates_test = zeros(30,1);
for k = 5:5
    
    options = statset('Display','final','MaxIter',2000);
    gm_1 = fitgmdist(class1_train,k,'CovType','diagonal','Regularize',0.1);
    gm_2 = fitgmdist(class2_train,k,'CovType','diagonal','Regularize',0.1);
    gm_3 = fitgmdist(class3_train,k,'CovType','diagonal','Regularize',0.1);
    gm_4 = fitgmdist(class4_train,k,'CovType','diagonal','Regularize',0.1);
    gm_5 = fitgmdist(class5_train,k,'CovType','diagonal','Regularize',0.1);
    
    
    p_train = [pdf(gm_1,train), pdf(gm_2,train), pdf(gm_3,train), pdf(gm_4,train), pdf(gm_5,train)];  
    [~,y_train]  = max(p_train,[],2);  
    
    
    p_val = [pdf(gm_1,val), pdf(gm_2,val), pdf(gm_3,val), pdf(gm_4,val), pdf(gm_5,val)];  
    [~,y_val]  = max(p_val,[],2);  
    
    p_test = [pdf(gm_1,test), pdf(gm_2,test), pdf(gm_3,test), pdf(gm_4,test), pdf(gm_5,test)];  
    [~,y_test]  = max(p_test,[],2);  
    
    [C_train,order1] = confusionmat(target_train,y_train);

    [C_test,order2] = confusionmat(target_test,y_test);
    [C_val,order3] = confusionmat(target_val,y_val);
    
    misclass_rates_train(k) =  (length(train) - sum(diag(C_train)))/length(train);
    misclass_rates_val(k) =  (length(val) - sum(diag(C_val)))/length(val);
    misclass_rates_test(k) = (length(test) - sum(diag(C_test)))/length(test);
    
end

%plot(1:30,misclass_rates_train,'b',1:30,misclass_rates_val,'r',1:30,misclass_rates_test,'g');

[~,k] = min(misclass_rates_val);
%ezcontour(@(x,y)pdf(gm_1,[x y]));

% K = 5 best.


