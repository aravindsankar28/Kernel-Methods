load('../../Data/multivariate/Group2.mat');

normal_indices = find(labels == 1);
abnormal_indices = find(labels == 2);

normal_data = data(normal_indices,:);
abnormal_data = data(abnormal_indices,:);

train = normal_data(1:96,:);
target_train = ones(size(train,1),1);

val = [normal_data(97:137,:); abnormal_data(1:40,:)];
target_val = [ones(size(normal_data(97:137,:),1),1); ones(size(abnormal_data(1:40,:),1),1)*(-1) ];


test = [normal_data(97:160,:); abnormal_data(41:137,:)];
target_test = [ones(size(normal_data(97:160,:),1),1); ones(size(abnormal_data(41:137,:),1),1)*(-1) ];

train_unscaled = train;
val_unscaled = val;
test_unscaled = test;

% Scale data

min_coord = zeros(size(train,2),1);
max_coord = zeros(size(train,2),1);	

for i=1:size(train,2)
    min_val = min(test(:,i));
    max_val = max(test(:,i));
    
    min_coord(i) = min_val;
    max_coord(i) = max_val;
    
    train(:,i) = (train(:,i)-min_val)/(max_val-min_val);
    val(:,i) = (val(:,i)-min_val)/(max_val-min_val);
    test(:,i) = (test(:,i)-min_val)/(max_val-min_val);
end

