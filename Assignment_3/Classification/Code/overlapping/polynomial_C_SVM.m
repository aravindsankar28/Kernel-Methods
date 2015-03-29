% Load and scale data
load_data

% Cross-validation to identify best C, g, degree
bestcv = 0;
for degree = 1:1:5,
   for log2c = -3:1:3,
       for log2g = -3:1:3,
           cmd = ['-q -s 0 -t 1 -c ',num2str(2^log2c),' -g ',num2str(2^log2g),' -d ',num2str(degree)];
           model = ovrtrain(target_train,train,cmd);
           [pred ac decv] = ovrpredict(target_val, val, model);
           if (ac >= bestcv),
             bestcv = ac; best_C = 2^log2c; best_degree = degree; best_g = 2^log2g; 
           end
           fprintf('deg=%g log2c=%g log2g=%g acc=%g (best degree=%g, C=%g, g=%g, acc=%g)\n', degree, log2c, log2g, ac, best_degree, best_C, best_g, bestcv);
       end
   end
end

% Final model train
cmd = ['-s 0 -t 1 -c ',num2str(best_C),' -g ',num2str(best_g),' -d ',num2str(best_degree)];
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

% Decision region plot for training data
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
[pred ac decv] = ovrpredict(ones(size(xy,1),1), xy, model);

figure;
decisionmap = reshape(pred, image_size);
imagesc(xrange,yrange,decisionmap);
hold on;
set(gca,'ydir','normal');
cmap = [1 0.8 0.8; 0.95 1 0.95; 0.9 0.9 1; 0.6 0.7 1];
colormap(cmap);

plot(class1_train(:,1),class1_train(:,2),'r*');
plot(class2_train(:,1),class2_train(:,2),'g*');
plot(class3_train(:,1),class3_train(:,2),'b*');
plot(class4_train(:,1),class4_train(:,2),'k*');

a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Decision region plot');