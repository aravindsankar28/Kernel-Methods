class1_train = load('../../Data/overlapping/class1_train.txt');
class2_train = load('../../Data/overlapping/class2_train.txt');

class1_val = load('../../Data/overlapping/class1_val.txt');
class2_val = load('../../Data/overlapping/class2_val.txt');

class1_test = load('../../Data/overlapping/class1_test.txt');
class2_test = load('../../Data/overlapping/class2_test.txt');

train = [class1_train; class2_train ];
target_train = [ones(length(class1_train),1); ones(length(class2_train),1)*2];

val = [class1_val; class2_val ];
target_val = [ones(length(class1_val),1); ones(length(class2_val),1)*2];

test = [class1_test; class2_test];
target_test = [ones(length(class1_test),1); ones(length(class2_test),1)*2];
