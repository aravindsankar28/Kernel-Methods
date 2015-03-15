class1_train = load('../../Data/overlapping/class1_train.txt');
class2_train = load('../../Data/overlapping/class2_train.txt');
class3_train = load('../../Data/overlapping/class3_train.txt');
class4_train = load('../../Data/overlapping/class4_train.txt');

class1_val = load('../../Data/overlapping/class1_val.txt');
class2_val = load('../../Data/overlapping/class2_val.txt');
class3_val = load('../../Data/overlapping/class3_val.txt');
class4_val = load('../../Data/overlapping/class4_val.txt');

class1_test = load('../../Data/overlapping/class1_test.txt');
class2_test = load('../../Data/overlapping/class2_test.txt');
class3_test = load('../../Data/overlapping/class3_test.txt');
class4_test = load('../../Data/overlapping/class4_test.txt');

train_data = [class1_train; class2_train ; class3_train;  class4_train ];
target_train = [ones(length(class1_train),1); ones(length(class2_train),1)*2; ones(length(class3_train),1)*3;ones(length(class4_train),1)*4;];
oneofk_target_train = zeros(length(target_train),4);
for i=1:length(target_train)
    oneofk_target_train(i,target_train(i))=1;
end

val = [class1_val; class2_val ; class3_val;  class4_val ];
target_val = [ones(length(class1_val),1); ones(length(class2_val),1)*2; ones(length(class3_val),1)*3;ones(length(class4_val),1)*4;];
oneofk_target_val = zeros(length(target_val),4);
for i=1:length(target_val)
    oneofk_target_val(i,target_val(i))=1;
end

test = [class1_test; class2_test ; class3_test;  class4_test ];
target_test = [ones(length(class1_test),1); ones(length(class2_test),1)*2; ones(length(class3_test),1)*3;ones(length(class4_test),1)*4;];
oneofk_target_test = zeros(length(target_test),4);
for i=1:length(target_test)
    oneofk_target_test(i,target_test(i))=1;
end

%For MLFFNN
data_input = [train_data;val;test];
data_target = [oneofk_target_train;oneofk_target_val;oneofk_target_test];
save('data.mat','data_input','data_target');