sigma = 0.1;
train_data = load('../../Data/bivariateData/group2_train.txt');
val_data = load('../../Data/bivariateData/group2_val.txt');
test_data = load('../../Data/bivariateData/group2_test.txt');


data_input = [train_data(:,1:2);val_data(:,1:2);test_data(:,1:2)];
data_target = [train_data(:,3);val_data(:,3);test_data(:,3)];

train = train_data(:,1:2);
val = val_data(:,1:2);
test = test_data(:,1:2);

target_train = train_data(:,3);
target_val = val_data(:,3);
target_test = test_data(:,3);

train_scaled = train;
val_scaled = val;
test_scaled = test;
% Scale data

min_coord = zeros(size(train_scaled,2),1);
max_coord = zeros(size(train_scaled,2),1);

for i=1:size(train_scaled,2)
    min_val = min(train_scaled(:,i));
    max_val = max(train_scaled(:,i));
    
    min_coord(i) = min_val;
    max_coord(i) = max_val;
    
    train_scaled(:,i) = (train_scaled(:,i)-min_val)/(max_val-min_val);
    val_scaled(:,i) = (val_scaled(:,i)-min_val)/(max_val-min_val);
    test_scaled(:,i) = (test_scaled(:,i)-min_val)/(max_val-min_val);
end


