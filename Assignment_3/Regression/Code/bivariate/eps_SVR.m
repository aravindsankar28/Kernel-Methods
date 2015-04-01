% Load and scale data
load_data;


% Cross-validation to identify best C, g
bestcv = Inf;
best_C = 0;
best_g = 0;
best_p = 0;

mse_train_eps = zeros(7,1);
mse_val_eps = zeros(7,1);
mse_test_eps = zeros(7,1);


i = 1;
for log2p = -3:1:3
    log2p
    local_best_cv = Inf;
    local_best_C = 0;
    local_best_g = 0;
    
    for log2c = -3:1:6
        for log2g = -3:1:6
            cmd = ['-q -s 3 -t 2 -c ',num2str(2^log2c),' -g ',num2str(2^log2g),' -p ',num2str(2^log2p)];
            model = svmtrain(target_train,train,cmd);
            
            [pred, ac, decv] = svmpredict(target_val, val, model,'-q');
            mse = ac(2);
            if (mse <= bestcv)
              bestcv = mse; best_C = 2^log2c; best_g = 2^log2g; best_p = 2^log2p;
            end
            if (mse <= local_best_cv)
                local_best_cv = mse; local_best_C = 2^log2c; local_best_g = 2^log2g;
            end
            
            fprintf('log2c=%g log2g=%g acc=%g (best C=%g, g=%g, acc=%g)\n', log2c, log2g, mse, best_C, best_g, bestcv);
        end
    end
    
    cmd = ['-q -s 3 -t 2 -c ',num2str(local_best_C),' -g ',num2str(local_best_g), ' -p ',num2str(2^log2p)];
    model = svmtrain(target_train,train,cmd);
    [~ ,ac, ~] = svmpredict(target_train, train, model,'-q');
    mse_train_eps(i) = ac(2);
    [~, ac, ~] = svmpredict(target_val, val, model,'-q');
    mse_val_eps(i) = ac(2);
    [~, ac, ~] = svmpredict(target_test, test, model,'-q');
    mse_test_eps(i) = ac(2);
    i = i +1;
end

bestcv,best_C,best_g,best_p


% MSE plot w.r.t eps
eps_range = 2.^(-3:1:3);
plot(eps_range,mse_train_eps,eps_range,mse_val_eps,eps_range,mse_test_eps);
legend('Train','Validation','Test');

a = title('MSE on varying $\epsilon$');
set(a,'Interpreter','latex');

return;
% Final model train
cmd = ['-s 3 -t 2 -c ',num2str(best_C),' -g ',num2str(best_g), ' -p ',num2str(best_p)];
model = svmtrain(target_train,train,cmd);

% Testing
[pred_train, ac, decv] = svmpredict(target_train, train, model);
mse_train = ac(2);
fprintf('Train MSE = %g%\n', mse_train);
[pred_val, ac, decv] = svmpredict(target_val, val, model);
mse_val = ac(2);
fprintf('Validation MSE = %g%\n', mse_val);
[pred_test, ac, decv] = svmpredict(target_test, test, model);
mse_test = ac(2);
fprintf('Test MSE = %g%\n', mse_test);
