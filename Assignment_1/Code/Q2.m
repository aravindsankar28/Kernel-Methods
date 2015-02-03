N_values = [20,100,1000]; % training set size
M_values = [3,9,15,200];  % no of basis functions
lambda_values = [0,10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),1,2,5]; % regularization parameter

% read in training dataset 
fId = fopen(strcat('../Data/group2/bivariateData/group2_train',num2str(N),'.txt'),'r');
sizeTrain = [N 3];
trainSet = fscanf(fId,'%f %f %f',sizeTrain);
fclose(fId);

% read in validation dataset 
fId = fopen('../Data/group2/bivariateData/group2_val.txt','r');
sizeVal = [300 3];
valSet = fscanf(fId,'%f %f %f',sizeVal);
fclose(fId);

% read in test dataset 
fId = fopen('../Data/group2/bivariateData/group2_test.txt','r');
sizeTest = [200 3];
testSet = fscanf(fId,'%f %f %f',sizeTest);
fclose(fId);

% Plots on varying M - note lambda = 0 here
N_values = [20]; % training set size
M_values = [3,9,15,200];  % no of basis functions

target_output = trainSet(:,3);
for i = 1:length(N_values)
    for j = 1:length(M_values)
        [coeffs,designMat,centroids,widthParam] = surface_fit(trainSet,N_values(i),M_values(j),0);
        model_output = designMat*coeffs;
        
        fig1 = figure;
        plot3(trainSet(:,1),trainSet(:,2),trainSet(:,3),'ro',trainSet(:,1),trainSet(:,2),trainSet(:,3),'bo');
        %, axis([-90,130,-20,150,-10,80]
        legend('t','y(x,w)');
    end
end