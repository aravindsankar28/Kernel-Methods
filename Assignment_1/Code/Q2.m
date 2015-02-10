N_values = [20,100,1000]; % training set size
M_values = [3,5,7,9,11,15,30,50,90,99];  % no of basis functions
lambda_values = [0,10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),1,10]; % regularization parameter

% read in training datasets 
% fId = fopen('../Data/group2/bivariateData/group2_train20.txt','r');
% sizeTrain = [20 3];
% trainSet_20 = fscanf(fId,'%f %f %f',sizeTrain);

%fclose(fId);

% fId = fopen('../Data/group2/bivariateData/group2_train100.txt','r');
% sizeTrain = [100 3];
% trainSet_100 = fscanf(fId,'%f %f %f',sizeTrain);
% fclose(fId);

% fId = fopen('../Data/group2/bivariateData/group2_train200.txt','r');
% sizeTrain = [200 3];
% trainSet_200 = fscanf(fId,'%f %f %f',sizeTrain);
% fclose(fId);

% fId = fopen('../Data/group2/bivariateData/group2_train400.txt','r');
% sizeTrain = [400 3];
% trainSet_400 = fscanf(fId,'%f %f %f',sizeTrain);
% fclose(fId);
% 
% fId = fopen('../Data/group2/bivariateData/group2_train700.txt','r');
% sizeTrain = [700 3];
% trainSet_700 = fscanf(fId,'%f %f %f',sizeTrain);
% fclose(fId);

% fId = fopen('../Data/group2/bivariateData/group2_train1000.txt','r');
% sizeTrain = [1000 3];
% trainSet_1000 = fscanf(fId,'%f %f %f',sizeTrain);
% fclose(fId);

trainSet_20 = load('../Data/group2/bivariateData/group2_train20.txt');
trainSet_100 = load('../Data/group2/bivariateData/group2_train100.txt');
trainSet_200 = load('../Data/group2/bivariateData/group2_train200.txt');
trainSet_400 = load('../Data/group2/bivariateData/group2_train400.txt');
trainSet_700 = load('../Data/group2/bivariateData/group2_train700.txt');
trainSet_1000 = load('../Data/group2/bivariateData/group2_train1000.txt');
trainSet_2000 = load('../Data/group2/bivariateData/group2_train.txt');
valSet = load('../Data/group2/bivariateData/group2_val.txt');
testSet = load('../Data/group2/bivariateData/group2_test.txt');


% read in validation dataset 
% fId = fopen('../Data/group2/bivariateData/group2_val.txt','r');
% sizeVal = [300 3];
% valSet = fscanf(fId,'%f %f %f',sizeVal);
% fclose(fId);
% 
% % read in test dataset 
% fId = fopen('../Data/group2/bivariateData/group2_test.txt','r');
% sizeTest = [200 3];
% testSet = fscanf(fId,'%f %f %f',sizeTest);
% fclose(fId);

%%%%%%%%%%%%%%%%%%% Surface Plots %%%%%%%%%%%%%%%%%%%

% Plots on varying M - note lambda = 0 here

%{
N_values = [400]; % training set size
M_values = [10,50,100,400];  % no of basis functions

for i = 1:length(N_values)
    for j = 1:length(M_values)
        eval(sprintf('trainSet = trainSet_%d;',N_values(i)));
        [coeffs,designMat,centroids,widthParam] = surface_fit(trainSet,N_values(i),M_values(j),0);
        model_output = designMat*coeffs;
          
        [x1,x2] = meshgrid(linspace(-10,10));
        y = zeros(size(x1,1),size(x1,2));
        basisVec = zeros(M_values(j),1);
        for k = 1:size(x1,1)
            for l = 1:size(x1,2)
                for m = 1:M_values(j)
                    basisVec(m,1) = exp(-((x1(k,l)-centroids(m,1))^2+(x2(k,l)-centroids(m,2))^2))/widthParam(m,1);
                end 
                y(k,l) = basisVec'*coeffs;
            end
        end
        
        fig1 = figure;
        plot3(trainSet(:,1),trainSet(:,2),trainSet(:,3),'ro');
        %axis([-10,10,-10,10,min(y(:)),max(y(:))]);
        hold on;
        
        %plot3(trainSet(:,1),trainSet(:,2),model_output,'bo');
        
        surf(x1,x2,y);
        
        legend('t','y(x,w)');
        a = strcat(('Plot of model and target output N = '),int2str(N_values(i)), ' and M = ',int2str(M_values(j)));
        title(a);
        xlabel('x_1 (input variable)');
        ylabel('x_2 (input variable)');
        zlabel('Model and Target output');
        legend('show');
        saveas(fig1,strcat('Plots_2/Varying_M/VaryingM_N',int2str(N_values(i)),'M',int2str(M_values(j)),'.png'));
        
    end
end
%}

% Plots on varying N - note lambda = 0 here

%{
N_values = [100,200,400,700,1000]; % training set size
M_values = [100];  % no of basis functions

for i = 1:length(N_values)
    for j = 1:length(M_values)
        eval(sprintf('trainSet = trainSet_%d;',N_values(i)));
        size(trainSet,1)
        [coeffs,designMat,centroids,widthParam] = surface_fit(trainSet,N_values(i),M_values(j),0);
        model_output = designMat*coeffs;
            
        [x1,x2] = meshgrid(linspace(-10,10));
        y = zeros(size(x1,1),size(x1,2));
        basisVec = zeros(M_values(j),1);
        for k = 1:size(x1,1)
            for l = 1:size(x1,2)
                for m = 1:M_values(j)
                    basisVec(m,1) = exp(-((x1(k,l)-centroids(m,1))^2+(x2(k,l)-centroids(m,2))^2))/widthParam(m,1);
                end 
                y(k,l) = basisVec'*coeffs;
            end
        end
        
        fig1 = figure;
        plot3(trainSet(:,1),trainSet(:,2),trainSet(:,3),'ro');
        %axis([-10,10,-10,10,min(y(:)),max(y(:))]);
        hold on;
        
        surf(x1,x2,y);
        
        legend('t','y(x,w)');
        a = strcat(('Plot of model and target output N = '),int2str(N_values(i)), ' and M = ',int2str(M_values(j)));
        title(a);
        xlabel('x_1 (input variable)');
        ylabel('x_2 (input variable)');
        zlabel('Model and Target output');
        legend('show');
        saveas(fig1,strcat('Plots_2/Varying_N/VaryingN_N',int2str(N_values(i)),'M',int2str(M_values(j)),'.png'));
        
    end
end
%}

% Plots on varying lambda

%{
N = 1000; % training set size
M = 1000;  % no of basis functions
lambda_values = [0,10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),1,10];

for i = 1:length(lambda_values)
    
    lambda = lambda_values(i);
    
    eval(sprintf('trainSet = trainSet_%d;',N));
    [coeffs,designMat,centroids,widthParam] = surface_fit(trainSet,N,M,lambda);
    model_output = designMat*coeffs;
            
    [x1,x2] = meshgrid(linspace(-10,10));
    y = zeros(size(x1,1),size(x1,2));
    basisVec = zeros(M,1);
    for k = 1:size(x1,1)
        for l = 1:size(x1,2)
            for m = 1:M
                basisVec(m,1) = exp(-((x1(k,l)-centroids(m,1))^2+(x2(k,l)-centroids(m,2))^2))/widthParam(m,1);
            end 
        y(k,l) = basisVec'*coeffs;
        end
    end
        
    fig1 = figure;
    plot3(trainSet(:,1),trainSet(:,2),trainSet(:,3),'ro');
    %axis([-10,10,-10,10,min(y(:)),max(y(:))]);
    hold on;
        
    surf(x1,x2,y);
        
    legend('t','y(x,w)');
    a = strcat(('Plot of model and target output N = '),int2str(N), ' and M = ',int2str(M),' for lambda = ',num2str(lambda));
    title(a);
    xlabel('x_1 (input variable)');
    ylabel('x_2 (input variable)');
    zlabel('Model and Target output');
    legend('show');
    saveas(fig1,strcat('Plots_2/Varying_lambda/Varyinglambda_N',int2str(N),'M',int2str(M),'lambda',num2str(lambda),'.png'));    
end
%}

%%%%%%%%%%%%RMS ERROR PLOTS%%%%%%%%%

% RMSE vs complexity 

%{

M_values = [10,30,50,100,200,400,500,600,700];  % no of basis functions
lambda_values = [0,10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),1,10];

train_rms = [];
test_rms = [];
val_rms = [];

for i=1:length(M_values)
    i
    [rtrain,rtest,rval] = rmserr_Q2_M(trainSet_700,testSet,valSet,M_values(i),lambda_values);
    train_rms = [train_rms,rtrain];
    test_rms = [test_rms,rtest];
    val_rms = [val_rms,rval];        
end

figure(1)
hold on;
plot(M_values,train_rms,'color','b','DisplayName','train');
plot(M_values,test_rms,'color','r','DisplayName','test');
plot(M_values,val_rms,'color','g','DisplayName','val');
hold off;
title('RMSE vs complexity')
ylabel('RMS error');
xlabel('Model Complexity');
legend('show');
saveas(gcf,'Plots_2/RMS/RMS_complexity_700.png');

%}

% RMSE vs lambda

%{

M_values = [10,30,50,100,200,300,400];  % no of basis functions
lambda_values = [0,10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),1,10];

train_rms = [];
test_rms = [];
val_rms = [];
for i=1:length(lambda_values)
    [rtrain,rtest,rval] = rmserr_Q2_lambda(trainSet_400,testSet,valSet,M_values,lambda_values(i));
    train_rms = [train_rms,rtrain];
    test_rms = [test_rms,rtest];
    val_rms = [val_rms,rval];        
end

figure(1)
hold on;
log_lambda_values = log(lambda_values);

plot(log_lambda_values,train_rms,'color','b','DisplayName','train');
plot(log_lambda_values,test_rms,'color','r','DisplayName','test');
plot(log_lambda_values,val_rms,'color','g','DisplayName','val');
hold off;
title('RMSE vs log(lambda)')
ylabel('RMS error');
xlabel('log(lambda)');
legend('show');
saveas(gcf,'Plots_2/RMS/RMS_lambda_400.png');

%}

%%%%%%%%%%%% SCATTER Plots %%%%%%%%%%%%%%%

% Scatter plots for varying N

%{
n_range = [1000];
m_range = [100];

for i = 1:length(n_range)
    for j = 1:length(m_range)
        
        N = n_range(i);
        M = m_range(j);
        
        fig1 = figure(1);
       % b = strcat('Scatter plot of model output Vs target output for N = ',int2str(N),' and M = ',int2str(M));
        
        eval(sprintf('trainSet = trainSet_%d;',N));
        [coeffs,designMat,centroids,widthParam] = surface_fit(trainSet,N,M,0);
        model_output = designMat*coeffs;
        target_output = trainSet(:,3);
        %scatter(model_output,target_output,'ko','filled'); 
        %axis equal;
        
        
        designMat_test = zeros(size(testSet,1),M);
        for i1=1:size(testSet,1)
            for j=1:M
                designMat_test(i1,j) = exp(-norm(testSet(i1,1:2)-centroids(j,:))^2)/widthParam(j,1);
            end
        end%
        
        scatter(designMat_test*coeffs,testSet(:,3),'ro','filled'); 
        b = strcat('Scatter plot of model output Vs target output for N = ',int2str(N),' and M = ',int2str(M),'on test data');
        %plot3(trainSet(:,2),trainSet(:,1),trainSet(:,3),'ro');
        %hold on;
        %plot3(trainSet(:,2),trainSet(:,1),model_output,'b*');
        
        %plot3(trainSet(:,2),trainSet(:,1),trainSet(:,3));
        ylabel('Target output');
        xlabel('Model output');
        title(b);
        
        saveas(fig1,strcat('Plots_2/Scatter/VaryingN/test_1000_100','.png'));
        %saveas(fig1,strcat('Plots_2/Scatter/VaryingN/VaryingN_N',int2str(N),'M',int2str(M),'.png'));
    end
end 
%}

% Scatter plots for varying M

%{
n_range = [400];
m_range = [10,50,100,400];

for i = 1:length(n_range)
    for j = 1:length(m_range)

        N = n_range(i);
        M = m_range(j);        
        
        fig1 = figure(1);
        b = strcat('Scatter plot of model output Vs target output for N = ',int2str(N),' and M = ',int2str(M));
        
        eval(sprintf('trainSet = trainSet_%d;',N));
        [coeffs,designMat,centroids,widthParam] = surface_fit(trainSet,N,M,0);
        model_output = designMat*coeffs;
        target_output = trainSet(:,3);
        scatter(model_output,target_output,'ko','filled');        
        
        ylabel('Target output');
        xlabel('Model output');
        title(b);
        saveas(fig1,strcat('Plots_2/Scatter/VaryingM/VaryingM_N',int2str(N),'M',int2str(M),'.png'));
    end
end
%}


% Scatter plots for varying lambda

%{
N = 400;
M = 400;
lambda_range = [0,10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),1,10];

for i = 1:length(lambda_range)
    
    lambda = lambda_range(i);
        
    fig1 = figure(1);
    b = strcat('Scatter plot of model output Vs target output for N = ',int2str(N),' and M = ',int2str(M),' lambda = ',num2str(lambda));
        
    eval(sprintf('trainSet = trainSet_%d;',N));
    [coeffs,designMat,centroids,widthParam] = surface_fit(trainSet,N,M,lambda);
    model_output = designMat*coeffs;
    target_output = trainSet(:,3);
    scatter(model_output,target_output,'ko','filled');        
        
    ylabel('Target output');
    xlabel('Model output');
    title(b);
    saveas(fig1,strcat('Plots_2/Scatter/Varying_lambda/Varyinglambda_N',int2str(N),'M',int2str(M),'lambda',num2str(lambda),'.png'));    
  
end

%}