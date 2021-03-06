% Load and scale data
load_data

% Cross-validation to identify best nu, g
bestcv = 0;
for nu=0.01:0.05:0.2,
    for log2g = -1:2:7,
        cmd = ['-q -s 1 -t 2 -n ',num2str(nu),' -g ',num2str(2^log2g)];
        model = ovrtrain(target_train,train,cmd);
        [pred ac decv] = ovrpredict(target_val, val, model);
        if (ac >= bestcv),
          bestcv = ac; best_nu = nu; best_g = 2^log2g; 
        end
        fprintf('nu=%g log2g=%g acc=%g (best nu=%g, g=%g, acc=%g)\n', nu, log2g, ac, best_nu, best_g, bestcv);
    end
end


% Final model train
cmd = ['-s 1 -t 2 -n ',num2str(best_nu),' -g ',num2str(best_g)];
model = ovrtrain(target_train,train,cmd);

% Testing
[pred_train ac decv] = ovrpredict(target_train, train, model);
fprintf('Train Accuracy = %g%%\n', ac * 100);
[pred_val ac decv] = ovrpredict(target_val, val, model);
fprintf('Validation Accuracy = %g%%\n', ac * 100);
[pred_test ac decv] = ovrpredict(target_test, test, model);
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

% Construct kernel matrix
train_kernel = exp(-best_g*pdist2(train,train).^2);
K = mat2gray(train_kernel);
figure, imshow(K)