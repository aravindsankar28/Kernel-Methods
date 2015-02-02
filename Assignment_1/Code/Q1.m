% Parameters
% sigma       - standard deviation of Gaussian noise
% N           - number of points to sample
% M           - model complexity
% lambda      - array of values to test for regularization

lambda_values = [0,10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),1,2,5];
sigma = 0.1;

validationSet = samplePoints(sigma,50);
testSet = samplePoints(sigma,50);

train_20 = samplePoints(sigma,20);
train_100 = samplePoints(sigma,100);
train_1000 = samplePoints(sigma,1000);


%fn = @(x) exp(cos(2*pi*x));
%fplot(fn,[0,1]);

lambda = 0.0;
M_values = [2,3,5,7,10,15];


% Plots on varying M - note lambda = 0 here
for i = 1:length(M_values)
    
    % Use Plot_fn as pass 1 as the last param
    %Plot_fn_1(train_1000,M_values(i),lambda,1);
    
%     coeffs = curve_fit(train_100,M_values(i),lambda);  
%     x = 0:.001:1;       
%     y1 = exp(cos(2*pi*x));
%     y2 = polyval(coeffs,x);
%     fig1 = figure;
%     
%     plot(train_100(:,1),train_100(:,2),'go',x,y1,'b',x,y2,'r'), axis([0,1,0,3]);
%     xlabel('x');
%     % Set appropriate legend here
%     legend('Data points','t','y(x,w)');
%     saveas(fig1,strcat('Plots_1/Varying_M_',int2str(M_values(i)),'.png')); 
    
end

% On varying train set size for some value of M - note lambda = 0 here

% Change M for different set  - use Plot_fn function and pass 2 as the last
% param
M = 9;

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
%{
for i=1:length(lambda_values)
    Plot_fn_1(train_20,M,lambda_values(i),3);
end
%}





%%%%%%%%%%%%RMS ERROR PLOTS%%%%%%%%%



%for train_20

cc = hsv(length(M_values));
train_rms = [];
test_rms = [];
val_rms = [];
%figrms_test = figure('Name','RMS error on test set for train_20');
for i=1:length(M_values)
    
    for j=1:length(lambda_values)
        [rtrain,rtest,rval] = rmserr_Q1(train_20,testSet,validationSet,M_values(i),lambda_values(j));
        train_rms = [train_rms,rtrain];
        test_rms = [test_rms,rtest];
        val_rms = [val_rms,rval];
    end        
end

train_rms = vec2mat(train_rms,length(lambda_values));
test_rms = vec2mat(test_rms,length(lambda_values));
val_rms = vec2mat(val_rms,length(lambda_values));

figure(1)
hold on;
for var = 1:size(train_rms,1)
plot(lambda_values,train_rms(var,:),'color',cc(var,:),'DisplayName',int2str(M_values(var)));
end
hold off;
title('RMSE on train data of 20 pts, plots for different complexities')
ylabel('RMS error');
xlabel('Regularization parameter');
legend('show');
saveas(gcf,'Plots_1/RMS/20_train.png');
clf;

figure(1)
hold on;
for var = 1:size(test_rms,1)
plot(lambda_values,test_rms(var,:),'color',cc(var,:),'DisplayName',int2str(M_values(var)));
end
hold off;
title('RMSE on test data,model trained on 20 pts, plots for different complexities')
ylabel('RMS error');
xlabel('Regularization parameter');
legend('show');
saveas(gcf,'Plots_1/RMS/20_test.png');
clf;



figure(1)
hold on;
for var = 1:size(val_rms,1)
plot(lambda_values,val_rms(var,:),'color',cc(var,:),'DisplayName',int2str(M_values(var)));
end
hold off;
title('RMSE on validation data,model trained on 20 pts, plots for different complexities')
ylabel('RMS error');
xlabel('Regularization parameter');
legend('show');
saveas(gcf,'Plots_1/RMS/20_val.png');
