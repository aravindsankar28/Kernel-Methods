% Load and scale data
load_data

% Cross-validation to identify best C
bestcv = 0;
for log2c = -1:2:3,
   cmd = ['-q -s 0 -t 0 -c ',num2str(2^log2c)];
   model = ovrtrain(target_train,train,cmd);
   [pred ac decv] = ovrpredict(target_val, val, model);
   if (ac >= bestcv),
     bestcv = ac; best_C = 2^log2c; 
   end
   fprintf('log2c=%g acc=%g (best C=%g, acc=%g)\n', log2c, ac, best_C, bestcv);
end

% Final model train
cmd = ['-s 0 -t 0 -c ',num2str(best_C)];
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
xrange = [-16 20];
yrange = [-16 20];
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

% Plotting support vectors

%w = ((((target_train(sv_indices(:,1))==1).*2)-1).*sv_indices(:,2))'*train(sv_indices(:,1),:);
%w0 = model.models{1}.rho;
for i = 1:4    
    sv_indices = [model.models{i}.sv_indices model.models{i}.sv_coef];
    idx_vector = (sv_indices(:,2) == -best_C) + (sv_indices(:,2) == best_C);
    bsv_indices = sv_indices(find(idx_vector)); % Find non-zero indices
    ubsv_indices = sv_indices(find(~idx_vector));  % Find zero indices
    
    w = model.models{i}.SVs' * model.models{i}.sv_coef;
    w0 = -model.models{i}.rho;
    if (model.models{i}.Label(1) == -1)
        w = -w; w0 = -w0;
    end

    plot_x = linspace(min(train(:,1)),max(train(:,1)),30);
    plot_y = (-1/w(2))*(w(1)*plot_x+w0);
    plot_1 = (-1/w(2))*(w(1)*plot_x+w0+1);
    plot_2 = (-1/w(2))*(w(1)*plot_x+w0-1);
    
    figure;
    hold on;
  
    plot(train(bsv_indices,1),train(bsv_indices,2),'g*'); % B-SV
    plot(train(ubsv_indices,1),train(ubsv_indices,2),'k*'); % U-SV

    %indices = (target_train(:)==i);
    %plot(train(indices,1),train(indices,2),'b*');
    %plot(train(~indices,1),train(~indices,2),'r*');

 
    all_indices = 1:size(train,1);
    remaining_indices = setdiff(all_indices,sv_indices(:,1))';
    remaining_labels = target_train(remaining_indices);
    positive_indices = remaining_indices(find(remaining_labels == i));
    negative_indices = remaining_indices(find(~(remaining_labels == i)));
    
    plot(train(positive_indices,1),train(positive_indices,2),'b*');
    hold on;
    
    
    plot(train(negative_indices,1),train(negative_indices,2),'r*');
    hold on;
    
    
    plot(plot_x,plot_y,'k-','LineWidth',1);
    hold on;
    
    plot(plot_x,plot_1,'r-','LineWidth',1);
    hold on;
    plot(plot_x,plot_2,'r-','LineWidth',1);
    
    a = xlabel('$x_1$');
    b = ylabel('$x_2$');
    set(a,'Interpreter','latex');
    set(b,'Interpreter','latex');
    title(strcat('Separating hyperplane for class ',num2str(i)));
    legend('B-SV','UB-SV','Positive class points','Other points');
end