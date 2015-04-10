load_data;           

bestcv = 0;
for nu = 0.01:0.001:0.4,
    for log2g = -6:1:6,
        
        cmd = ['-q -s 2 -t 2 -n ',num2str(nu),' -g ',num2str(2^log2g)];
        model = svmtrain(target_train,train,cmd);
        [pred ac decv] = svmpredict(target_val, val, model);
        
        ac = ac(1);
        if (ac > bestcv),
          bestcv = ac; best_nu = nu; best_g = 2^log2g; 
        end
        fprintf('nu=%g log2g=%g acc=%g (best nu=%g, g=%g, acc=%g) \n', nu, log2g, ac, best_nu, best_g, bestcv);
    end
end

best_nu,best_g,bestcv
% Final model train
cmd = ['-s 2 -t 2 -n ',num2str(best_nu),' -g ',num2str(best_g)];
model = svmtrain(target_train,train,cmd);


[pred_train ac decv] = svmpredict(target_train, train, model);
fprintf('Train Accuracy = %g%%\n', ac(1));
[pred_val ac decv] = svmpredict(target_val, val, model);
fprintf('Validation Accuracy = %g%%\n', ac(1));
[pred_test ac decv] = svmpredict(target_test, test, model);
fprintf('Test Accuracy = %g%%\n', ac(1));


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

% TODO : true postives, etc.

