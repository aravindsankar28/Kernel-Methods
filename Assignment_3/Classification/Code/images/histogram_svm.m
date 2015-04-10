% Load and scale data
load_data

% Construct kernel matrix
distance_kernel = @(x,Y) sum(bsxfun(@min,x,Y),2);
train_kernel = [(1:size(train,1))', pdist2(train,train,distance_kernel)];
val_kernel = [(1:size(val,1))', pdist2(val,train,distance_kernel)];
test_kernel = [(1:size(test,1))', pdist2(test,train,distance_kernel)];

% Final model train
cmd = '-t 4';
model = ovrtrain(target_train,train_kernel,cmd);

% Testing
[pred_train ac decv] = ovrpredict(target_train, train_kernel, model);
fprintf('Train Accuracy = %g%%\n', ac * 100);
[pred_val ac decv] = ovrpredict(target_val, val_kernel, model);
fprintf('Validation Accuracy = %g%%\n', ac * 100);
[pred_test ac decv] = ovrpredict(target_test, test_kernel, model);
fprintf('Test Accuracy = %g%%\n', ac * 100);

% Confusion matrices
fprintf('Train confusion matrix')
[C_train,order1] = confusionmat(target_train,pred_train);
C_train

fprintf('Validation confusion matrix')
[C_val,order2] = confusionmat(target_val,pred_val);
C_val

fprintf('Test confusion matrix')
[C_test,order3] = confusionmat(target_test,pred_test);
C_test 