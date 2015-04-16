% Load and scale data
load_data;

% Cross-validation to identify best C, g
bestcv = Inf;
best_C = 0;
best_g = 0;
best_p = 0;

mse_train_eps = zeros(10,1);
mse_val_eps = zeros(10,1);
mse_test_eps = zeros(10,1);

i = 1;
for log2p = -3:1:-3
    
    local_best_cv = Inf;
    local_best_C = 0;
    local_best_g = 0;
    
    for log2c = -3:1:8
        for log2g = -4:1:6,
            cmd = ['-q -s 3 -t 2 -c ',num2str(2^log2c),' -g ',num2str(2^log2g),' -p ',num2str(2^log2p)];
            model = svmtrain(target_train,train,cmd);
            
            [pred, ac, decv] = svmpredict(target_val, val, model);
            mse = ac(2);
            if (mse <= bestcv)
              bestcv = mse; best_C = 2^log2c; best_g = 2^log2g; best_p = 2^log2p;
            end
            if (mse <= local_best_cv)
                local_best_cv = mse; local_best_C = 2^log2c; local_best_g = 2^log2g;
            end
            
            %fprintf('log2c=%g log2g=%g acc=%g (best C=%g, g=%g, acc=%g)\n', log2c, log2g, mse, best_C, best_g, bestcv);
        end
    end
    cmd = ['-s 3 -t 2 -c ',num2str(local_best_C),' -g ',num2str(local_best_g), ' -p ',num2str(2^log2p)];
    model = svmtrain(target_train,train,cmd);
    [~ ,ac, ~] = svmpredict(target_train, train, model);
    mse_train_eps(i) = ac(2);
    [~, ac, ~] = svmpredict(target_val, val, model);
    mse_val_eps(i) = ac(2);
    [~, ac, ~] = svmpredict(target_test, test, model);
    mse_test_eps(i) = ac(2);
    i = i +1;
end


bestcv,best_C,best_g,best_p

% MSE plot w.r.t eps
eps_range = 2.^(-8:1:1);
plot(eps_range,mse_train_eps,eps_range,mse_val_eps,eps_range,mse_test_eps);
legend('Train','Validation','Test');

a = title('MSE on varying $\epsilon$');
set(a,'Interpreter','latex');
b = xlabel('$\epsilon$');
ylabel('MSE');
set(b,'Interpreter','latex');


% Final model train
cmd = ['-s 3 -t 2 -c ',num2str(best_C),' -g ',num2str(best_g), ' -p ',num2str(best_p)];
model = svmtrain(target_train,train,cmd);

% Testing
[pred_train, ac, decv] = svmpredict(target_train, train, model);
mse_train = ac(2);
fprintf('Train MSE = %g%%\n', mse_train);
[pred_val, ac, decv] = svmpredict(target_val, val, model);
mse_val = ac(2);
fprintf('Validation MSE = %g%%\n', mse_val);
[pred_test, ac, decv] = svmpredict(target_test, test, model);
mse_test = ac(2);
fprintf('Test MSE = %g%%\n', mse_test);

% Plot of true fn, t, approx. fn, eps tube.

% pred_values contains model output for the discretized x-axis.
x_range = (0:0.001:1)';
figure;
plot(x_range,exp(cos(2*pi*x_range)),'r');
hold on;
[pred_values,~,~] = svmpredict(zeros(length(x_range),1), x_range, model);
plot(x_range,pred_values,'b');
hold on;
plot(x_range,pred_values-best_p,'k--',x_range,pred_values+best_p,'k--');
a = legend('True function','Approximated function','$\epsilon$ tube above','$\epsilon$ tube below');
set(a,'Interpreter','latex');
b = title('Plot showing true function, approximated function and $\epsilon$ tube');
set(b,'Interpreter','latex');


% Now plotting target outputs etc along with true fn. and eps tube.
figure;
plot(x_range,exp(cos(2*pi*x_range)),'r');
hold on;
scatter(train,target_train,'b.');
hold on;
plot(x_range,pred_values-best_p,'k--',x_range,pred_values+best_p,'k--');

a = legend('True function','Target output','$\epsilon$ tube above','$\epsilon$ tube below');
set(a,'Interpreter','latex');
b = title('Plot showing true function, targets and epsilon tube');
set(b,'Interpreter','latex');


% Plot SV's here.
figure;

plot(x_range,pred_values,'g');
hold on;
plot(x_range,pred_values-best_p,'k--',x_range,pred_values+best_p,'k--');
sv_indices = [model.sv_indices model.sv_coef];
idx_vector = (sv_indices(:,2) == -best_C) + (sv_indices(:,2) == best_C);
bsv_indices = sv_indices(find(idx_vector)); % Find non-zero indices.
ubsv_indices = sv_indices(find(~idx_vector));  % Find zero indices.

% entry is 1 => BSV else UBSV.

scatter(train(bsv_indices),target_train(bsv_indices),'r.');
hold on;

scatter(train(ubsv_indices(:,1)),target_train(ubsv_indices(:,1)),'b.');
hold on;

a = legend('Approximated function','$\epsilon$ tube above','$\epsilon$ tube below','Bounded SVs','Unbounded Svs');
set(a,'Interpreter','latex');
b = title('Plot showing approximated function, epsilon tube and support vectors');
set(b,'Interpreter','latex');



% Scatter plots here. train - target on x and model on y.
x_range = 0:0.1:3;
figure;
scatter(target_train,pred_train,'k.');
hold on;
plot(x_range,x_range,'m');

title('Scatter plot of Model Vs Target output - train data');
xlabel('Target output');
ylabel('Model output');
legend('Scatter plot','Ideal y = x');

% Scatter plots here. val - target on x and model on y.
figure;
scatter(target_val,pred_val,'r.');
hold on;
plot(x_range,x_range,'m');

title('Scatter plot of Model Vs Target output - validation data');
xlabel('Target output');
ylabel('Model output');
legend('Scatter plot','Ideal y = x');

% Scatter plots here. test  - target on x and model on y.
figure;
scatter(target_test,pred_test,'b.');
hold on;
plot(x_range,x_range,'m');

title('Scatter plot of Model Vs Target output - test data');
xlabel('Target output');
ylabel('Model output');
legend('Scatter plot','Ideal y = x');
