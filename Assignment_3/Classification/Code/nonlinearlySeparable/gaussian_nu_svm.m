% Load and scale data
load_data

% Cross-validation to identify best nu, g
bestcv = 0;
for nu = 0.1:0.05:0.4,
    for log2g = -3:1:3,
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

% Decision region plot for training data
xrange = [-2 2];
yrange = [-2 2];
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

a = xlabel('$x_1$');
b = ylabel('$x_2$');
set(a,'Interpreter','latex');
set(b,'Interpreter','latex');
title('Decision region plot');