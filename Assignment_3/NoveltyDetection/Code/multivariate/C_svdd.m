load_data;           

bestcv = 0;
for log2c = -6:1:8,
    for log2g = -6:1:8,
        
        cmd = ['-q -s 5 -t 2 -c ',num2str(2^log2c),' -g ',num2str(2^log2g)];
        model = svmtrain(target_train,train,cmd);
        [pred ac decv] = svmpredict(target_val, val, model);
        
        ac = ac(1);
        if (ac >= bestcv),
          bestcv = ac; best_C = 2^log2c; best_g = 2^log2g; 
        end
        fprintf('log2c=%g log2g=%g acc=%g (best C=%g, g=%g, acc=%g) \n', log2c, log2g, ac, best_C, best_g, bestcv);
    end
end

best_C,best_g,bestcv
% Final model train
cmd = ['-s 5 -t 2 -c ',num2str(best_C),' -g ',num2str(best_g)];
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