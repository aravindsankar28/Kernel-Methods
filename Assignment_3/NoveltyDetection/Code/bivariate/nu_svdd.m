load_data;

% Cross-validation to identify best C, g
bestcv = 0;

for nu = 0.01:0.01:0.3
    for log2g = -10:1:10,
        
        cmd = ['-q -s 2 -t 2 -n ',num2str(nu),' -g ',num2str(2^log2g)];
        model = svmtrain(target_train,train,cmd);
        [pred ac decv] = svmpredict(target_val, val, model);
        
        ac = ac(1);
        if (ac > bestcv)
          bestcv = ac; best_nu = nu; best_g = 2^log2g; 
        end
        ac(1)
        %fprintf('nu=%g log2g=%g acc=%g (best nu=%g, g=%g, best acc=%g) \n', nu, log2g, ac, best_nu, best_g, bestcv);
    end
    
end


best_nu,best_g,bestcv
% Final model train
cmd = ['-s 2 -t 2 -n ',num2str(best_nu),' -g ',num2str(best_g)];
model = svmtrain(target_train,train,cmd);


% Here normal class is +1 and abnormal is -1.

% Testing
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


% TODO
fprintf('Percentage of true positives train  = %g%%\n',C_train(2,2)*100/double(C_train(2,2)+C_train(2,1)));
fprintf('Percentage of true positives val  = %g%%\n',C_val(2,2)*100/double(C_val(2,2)+C_val(2,1)));
fprintf('Percentage of true positives test  = %g%%\n',C_test(2,2)*100/double(C_test(2,2)+C_test(2,1)));


% Plotting training, val and test data point predictions.



normal_points_train = train_unscaled(pred_train == 1,:);
abnormal_points_train  = train_unscaled(pred_train == -1,:);


figure,plot(normal_points_train(:,1),normal_points_train(:,2),'r.');
hold on;
plot(abnormal_points_train(:,1),abnormal_points_train(:,2),'b.');
legend('Normal points','Abnormal points');
title('Predictions made by nu-SVDD on training data');



% val
normal_points_val = val_unscaled(pred_val == 1,:);
abnormal_points_val  = val_unscaled(pred_val == -1,:);

normal_points_val_target = val_unscaled(target_val == 1,:);
abnormal_points_val_target  = val_unscaled(target_val == -1,:);


figure,plot(normal_points_val_target(:,1),normal_points_val_target(:,2),'ro');
hold on;
plot(abnormal_points_val_target(:,1),abnormal_points_val_target(:,2),'bo');

hold on;
plot(normal_points_val(:,1),normal_points_val(:,2),'r.');
hold on;
plot(abnormal_points_val(:,1),abnormal_points_val(:,2),'b.');


legend('Actual Normal points ','Actual Abnormal points','Predicted normal points','Predicted abnormal points');
title('Results of nu-SVDD on validation data');


% test

normal_points_test = test_unscaled(pred_test == 1,:);
abnormal_points_test  = test_unscaled(pred_test == -1,:);

normal_points_test_target = test_unscaled(target_test == 1,:);
abnormal_points_test_target  = test_unscaled(target_test == -1,:);


figure,plot(normal_points_test_target(:,1),normal_points_test_target(:,2),'ro');
hold on;
plot(abnormal_points_test_target(:,1),abnormal_points_test_target(:,2),'bo');

hold on;
plot(normal_points_test(:,1),normal_points_test(:,2),'r.');
hold on;
plot(abnormal_points_test(:,1),abnormal_points_test(:,2),'b.');


legend('Actual Normal points ','Actual Abnormal points','Predicted normal points','Predicted abnormal points');
title('Results of nu-SVDD on test data');



% Decision region plot


xrange = [-6 12];
yrange = [-6 12];

inc = 0.1;
[x, y] = meshgrid(xrange(1):inc:xrange(2), yrange(1):inc:yrange(2)); 
image_size = size(x); 
xy = [x(:) y(:)]; % make (x,y) pairs as a bunch of row vectors.

%Scale xy
for i=1:size(xy,2)
    xy(:,i) = (xy(:,i)-min_coord(i))/(max_coord(i)-min_coord(i));
end
[pred ac decv] = svmpredict(ones(size(xy,1),1), xy, model);

figure;
decisionmap = reshape(pred, image_size);
imagesc(xrange,yrange,decisionmap);
hold on;
set(gca,'ydir','normal');
cmap = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1; 0.6 0.7 1];
colormap(cmap);


plot(train_unscaled(:,1),train_unscaled(:,2),'b.');
% 
% plot(class1_train(:,1),class1_train(:,2),'r*');
% plot(class2_train(:,1),class2_train(:,2),'g*');
% plot(class3_train(:,1),class3_train(:,2),'b*');
% plot(class4_train(:,1),class4_train(:,2),'k*');

a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
%title('Decision region plot showing boundary between normal and abnormal classes');

% Plotting support vectors

sv_indices = [model.sv_indices model.sv_coef];
idx_vector = (sv_indices(:,2) == 1);
bsv_indices = sv_indices(find(idx_vector)); % Find non-zero indices.
ubsv_indices = sv_indices(find(~idx_vector));  % Find zero indices.


scatter(train_unscaled(:,1),train_unscaled(:,2),'k.');
hold on;
scatter(train_unscaled(bsv_indices,1),train_unscaled(bsv_indices,2),'r.');
hold on;

scatter(train_unscaled(ubsv_indices,1),train_unscaled(ubsv_indices,2),'b.');
hold on;

title('Plot of bounded and unbounded support vectors');
legend('Training data points','Bounded SV vectors','Unbounded SV vectors');

