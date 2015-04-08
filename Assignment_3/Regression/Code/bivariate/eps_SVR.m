% Load and scale data
load_data;


% Cross-validation to identify best C, g
bestcv = Inf;
best_C = 0;
best_g = 0;
best_p = 0;

mse_train_eps = zeros(8,1);
mse_val_eps = zeros(8,1);
mse_test_eps = zeros(8,1);


i = 1;
for log2p = -4:1:3
    log2p
    local_best_cv = Inf;
    local_best_C = 0;
    local_best_g = 0;
    
    for log2c = -2:1:9
        for log2g = -10:1:3
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
eps_range = 2.^(-4:1:3);
plot(eps_range,mse_train_eps,eps_range,mse_val_eps,eps_range,mse_test_eps);
legend('Train','Validation','Test');

b = xlabel('$\epsilon$');
ylabel('MSE');
a = title('MSE on varying $\epsilon$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');


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

xrange = [-10 10];
yrange = [-10 10];
inc = 0.1;
[x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2)); 
image_size = size(x); 
xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.

[pred_values, ac, decv] = svmpredict(zeros(length(xy),1), xy, model);

% Plot of approximated function
figure,plot3(xy(:,1),xy(:,2),pred_values,'r.');
a = title('Plot of approximated function over the $x_1$-$x_2$ space');
b = xlabel('$x_1$');
c = ylabel('$x_2$');
d = zlabel('f(x)');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
set(c,'Interpreter','latex');
set(d,'Interpreter','latex');

% Plots of model and target output for train data.

figure,plot3(train(:,1),train(:,2),target_train,'b.',train(:,1),train(:,2),pred_train,'r.');

a = title('Model output and target output for training data');
b = xlabel('$x_1$');
c = ylabel('$x_2$');

legend('Target output','Model output');
set(b,'Interpreter','latex');
set(c,'Interpreter','latex');



% Plots of model and target output for validation data.

figure,plot3(val(:,1),val(:,2),target_val,'b.',val(:,1),val(:,2),pred_val,'r.');

a = title('Model output and target output for validation data');
b = xlabel('$x_1$');
c = ylabel('$x_2$');

legend('Target output','Model output');
set(b,'Interpreter','latex');
set(c,'Interpreter','latex');



% Plots of model and target output for test data.

figure,plot3(test(:,1),test(:,2),target_test,'b.',test(:,1),test(:,2),pred_test,'r.');

a = title('Model output and target output for test data');
b = xlabel('$x_1$');
c = ylabel('$x_2$');

legend('Target output','Model output');
set(b,'Interpreter','latex');
set(c,'Interpreter','latex');



% Scatter plots here. train - target on x and model on y.
x_range = -30:1:200;
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
