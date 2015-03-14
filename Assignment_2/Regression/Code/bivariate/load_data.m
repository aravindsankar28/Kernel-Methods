sigma = 0.1;
train_data = load('../../Data/bivariateData/group2_train.txt');
val_data = load('../../Data/bivariateData/group2_val.txt');
test_data = load('../../Data/bivariateData/group2_test.txt');


data_input = [train_data(:,1:2);val_data(:,1:2);test_data(:,1:2)];
data_target = [train_data(:,3);val_data(:,3);test_data(:,3)];

