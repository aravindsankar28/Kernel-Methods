% Parameters
% sigma       - standard deviation of Gaussian noise
% N           - number of points to sample
% M           - model complexity
% lambda      - array of values to test for regularization


sigma = 0.1;

validationSet = samplePoints(sigma,50);
testSet = samplePoints(sigma,50);

train_20 = samplePoints(sigma,20);
train_100 = samplePoints(sigma,100);
train_1000 = samplePoints(sigma,1000);


%fn = @(x) exp(cos(2*pi*x));
%fplot(fn,[0,1]);
M_values = [];
for i = 1:20
    M_values = [M_values,i];
end

lambda_values = [];
for i = -40:1
    lambda_values = [lambda_values,exp(i)];
end


cc = hsv(length(M_values)+2);
a = cc(1,:);
cc(1,:) = cc(3,:);
cc(3,:) = a;
% Plots on varying M - note lambda = 0 here

% legend_names=cell(1,4);
% x = 0:.001:1;       
% y1 = exp(cos(2*pi*x));
% plot(train_100(:,1),train_100(:,2),'o','color',cc(1,:));
% hold on;
% plot(x,y1,'color',cc(2,:));
% hold on;
% legend_names{1} = 'Data points';
% legend_names{2} = 'Target function';
% for i = 1:length(M_values)    
%      coeffs = curve_fit(train_100,M_values(i),lambda);  
%      x = 0:.001:1;       
%      y1 = exp(cos(2*pi*x));
%      y2 = polyval(coeffs,x);
% 
%      plot(x,y2,'color',cc(i+2,:)), axis([0,1,0,3]);
%       xlabel('x');
%       hold on;  
%      legend_names{i+2} = strcat('M = ',int2str(M_values(i)));
%      
%  end
% legend(legend_names);



%for i = 1:length(M_values)
%    Plot_fn_1(train_1000,M_values(i),lambda,1);
%end


%
%saveas(gcf,strcat('Plots_1/Varying_M/',int2str(length(train_20)),'.png'));

% On varying train set size for some value of M - note lambda = 0 here

% Change M for different set  - use Plot_fn function and pass 2 as the last
% param
M = 15;
% 
% Plot_fn_1(train_20,M,0,2);
% Plot_fn_1(train_100,M,0,2);
% Plot_fn_1(train_1000,M,0,2);


% Todo - varying lambda .



%coeffs = curve_fit([0:0.1:1],3);
%figure
%plot([0:0.1:1],polyval(coeffs,[0:0.1:1]));

%{
val_error = zeros(size(lambda,2),1);
for i1 = 1:size(lambda,2)
    coeffs = curve_fit(train,M,lambda(i1));
    error = 0;
    for i2 = 1:size(val,1)
        error = error + ((polyval(coeffs,val(i2,1)) - val(i2,2))^2);
    end
    error = sqrt(error/size(val,1));
    val_error(i1) = error;
end

val_error
%}


% M = 9;
% 
% for i=1:length(lambda_values)
%     Plot_fn_1(train_20,M,lambda_values(i),3);
% end





%%%%%%%%%%%%RMS ERROR PLOTS%%%%%%%%%




%%%%%%%%%%%%RMS ERROR PLOTS%%%%%%%%%


cc = hsv(length(M_values));
train_rms = [];
test_rms = [];
val_rms = [];
%figrms_test = figure('Name','RMS error on test set for train_20');
for i=1:length(M_values)
    [rtrain,rtest,rval] = rmserr_Q1_M(train_20,testSet,validationSet,M_values(i),lambda_values);
    train_rms = [train_rms,rtrain];
    test_rms = [test_rms,rtest];
    val_rms = [val_rms,rval];        
end

%train_rms = vec2mat(train_rms,length(lambda_values));
%test_rms = vec2mat(test_rms,length(lambda_values));
%val_rms = vec2mat(val_rms,length(lambda_values));

figure(1)
hold on;
%for var = 1:size(train_rms,1)
%plot(lambda_values,train_rms(var,:),'color',cc(var,:),'DisplayName',int2str(M_values(var)));
%end
plot(M_values,train_rms,'color','b','DisplayName','train');
plot(M_values,test_rms,'color','r','DisplayName','test');
plot(M_values,val_rms,'color','g','DisplayName','val');
hold off;
title('RMSE vs complexity')
ylabel('RMS error');
xlabel('Model Complexity');
legend('show');
saveas(gcf,'Plots_1/RMS/RMS_complexity_20.png');
clf;






train_rms = [];
test_rms = [];
val_rms = [];
%figrms_test = figure('Name','RMS error on test set for train_20');
for i=1:length(lambda_values)
    [rtrain,rtest,rval] = rmserr_Q1_lambda(train_20,testSet,validationSet,M_values,lambda_values(i));
    train_rms = [train_rms,rtrain];
    test_rms = [test_rms,rtest];
    val_rms = [val_rms,rval];        
end

%train_rms = vec2mat(train_rms,length(lambda_values));
%test_rms = vec2mat(test_rms,length(lambda_values));
%val_rms = vec2mat(val_rms,length(lambda_values));

figure(1)
hold on;
%for var = 1:size(train_rms,1)
%plot(lambda_values,train_rms(var,:),'color',cc(var,:),'DisplayName',int2str(M_values(var)));
%end
log_lambda_values = log(lambda_values);

plot(log_lambda_values,train_rms,'color','b','DisplayName','train');
plot(log_lambda_values,test_rms,'color','r','DisplayName','test');
plot(log_lambda_values,val_rms,'color','g','DisplayName','val');
hold off;
title('RMSE vs log(lambda)')
ylabel('RMS error');
xlabel('log(lambda)');
legend('show');
saveas(gcf,'Plots_1/RMS/RMS_lambda_20.png');
clf;

