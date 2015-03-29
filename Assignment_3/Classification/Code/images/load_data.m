% Load data

load('../../Data/images/CompleteData.mat');
class1_data = CompleteData{9};
%class1_data = class1_data(1:140,:);
CompleteData(9,2)

class2_data = CompleteData{4};
%class2_data = class2_data(1:140,:);
CompleteData(4,2)

class3_data = CompleteData{11};
%class3_data = class3_data(1:140,:);
CompleteData(11,2)

class4_data = CompleteData{10};
%class4_data = class4_data(1:140,:);
CompleteData(10,2)

class5_data = CompleteData{1};
%class5_data = class5_data(1:140,:);
CompleteData(1,2)

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

% Scale data

min_coord = zeros(size(train,2),1);
max_coord = zeros(size(train,2),1);
for i=1:size(train,2)
    min_val = min(train(:,i));
    max_val = max(train(:,i));
    
    min_coord(i) = min_val;
    max_coord(i) = max_val;
    
    train(:,i) = (train(:,i)-min_val)/(max_val-min_val);
    val(:,i) = (val(:,i)-min_val)/(max_val-min_val);
    test(:,i) = (test(:,i)-min_val)/(max_val-min_val);
end