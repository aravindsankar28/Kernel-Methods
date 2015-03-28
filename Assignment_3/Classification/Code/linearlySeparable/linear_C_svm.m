% Load and scale data
load_data

% Cross-validation to identify best C
best_C = 1.0;

% Final model train
cmd = ['-s 0 -t 0 -c ',num2str(best_C)];
model = ovrtrain(target_train,train,cmd);

% Test
[pred ac decv] = ovrpredict(target_test, test, model);
fprintf('Accuracy = %g%%\n', ac * 100);