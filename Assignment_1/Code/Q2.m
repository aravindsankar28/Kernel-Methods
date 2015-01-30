N = 20; % training set size
M = 5;  % no of basis functions

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

% perform k-means clustering
[idx,centroids] = kmeans(trainSet(:,1:2),M);

% setting width parameter: 
% http://chem-eng.utoronto.ca/~datamining/dmc/artificial_neural_network_rbf.htm
[IDX,D] = knnsearch(centroids,centroids,'K',3);
widthParam = (D(:,2)+D(:,3))/2; % s is set to be the average distance from the two nearest neighboring cluster centers

% constructing design matrix
designMat = zeros(N,M);
for i=1:N
    for j=1:M
        designMat(i,j) = exp(-norm(trainSet(i,1:2)-centroids(j,:))^2)/widthParam(j,1);
    end
end

% estimating coefficients
coeffs = pinv(designMat)*trainSet(:,3);

model_output = designMat*coeffs;
target_output = trainSet(:,3);