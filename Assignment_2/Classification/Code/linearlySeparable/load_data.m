class1_train = load('../../Data/linearlySeparable/class1_train.txt');
class2_train = load('../../Data/linearlySeparable/class2_train.txt');
class3_train = load('../../Data/linearlySeparable/class3_train.txt');
class4_train = load('../../Data/linearlySeparable/class4_train.txt');

class1_val = load('../../Data/linearlySeparable/class1_val.txt');
class2_val = load('../../Data/linearlySeparable/class2_val.txt');
class3_val = load('../../Data/linearlySeparable/class3_val.txt');
class4_val = load('../../Data/linearlySeparable/class4_val.txt');

class1_test = load('../../Data/linearlySeparable/class1_test.txt');
class2_test = load('../../Data/linearlySeparable/class2_test.txt');
class3_test = load('../../Data/linearlySeparable/class3_test.txt');
class4_test = load('../../Data/linearlySeparable/class4_test.txt');

train = [class1_train; class2_train ; class3_train;  class4_train ];
target_train = [ones(length(class1_train),1); ones(length(class2_train),1)*2; ones(length(class3_train),1)*3;ones(length(class4_train),1)*4;];

val = [class1_val; class2_val ; class3_val;  class4_val ];
target_val = [ones(length(class1_val),1); ones(length(class2_val),1)*2; ones(length(class3_val),1)*3;ones(length(class4_val),1)*4;];

test = [class1_test; class2_test ; class3_test;  class4_test ];
target_test = [ones(length(class1_test),1); ones(length(class2_test),1)*2; ones(length(class3_test),1)*3;ones(length(class4_test),1)*4;];
