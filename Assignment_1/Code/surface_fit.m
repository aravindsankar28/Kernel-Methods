function [coeffs,designMat,centroids,widthParam] = surface_fit(trainSet,N,M,lambda)

% perform k-means clustering
[idx,centroids] = kmeans(trainSet(:,1:2),M,'replicate',20,'EmptyAction','drop');

%scatter(trainSet(:,2),trainSet(:,1),[],idx);

% setting width parameter: 
% http://chem-eng.utoronto.ca/~datamining/dmc/artificial_neural_network_rbf.htm
[IDX,D] = knnsearch(centroids,centroids,'K',3);
widthParam = (D(:,2)+D(:,3))/2; % s is set to be the average distance from the two nearest neighboring cluster centers

%widthParam = ones(M,1)*1;

% constructing design matrix
designMat = zeros(N,M);
for i=1:N
    for j=1:M
        designMat(i,j) = exp(-(norm(trainSet(i,1:2)-centroids(j,:)))^2)/widthParam(j,1);
    end
end

% estimating coefficients
if lambda ==0
    coeffs = pinv(designMat)*trainSet(:,3);
else
    coeffs = inv((designMat'*designMat)+(lambda*eye(M)))*designMat'*trainSet(:,3);
end