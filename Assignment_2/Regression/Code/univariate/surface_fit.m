function [coeffs,designMat,centroids,widthParam,phi_tilda] = surface_fit(trainSet,targets,N,M,lambda)

% perform k-means clustering
[idx,centroids] = kmeans(trainSet,M,'replicate',20,'EmptyAction','singleton');

%scatter(trainSet(:,2),trainSet(:,1),[],idx);

% setting width parameter: 
%[IDX,D] = knnsearch(centroids,centroids,'K',3);
%widthParam = (D(:,2)+D(:,3))/2; % s is set to be the average distance from the two nearest neighboring cluster centers

s = 0.0;
for i = 1:M
    for j = 1:M
       s = max(s, norm(centroids(j,:) - centroids(i,:))/sqrt(2*M) );
    end
end

widthParam = s;

% constructing design matrix
designMat = zeros(N,M);

for i=1:N
    for j=1:M
        designMat(i,j) = exp((-(norm(trainSet(i,:)-centroids(j,:)))^2)/widthParam);
    end
end

phi_tilda = zeros(M,M);

for i = 1:M
    for j = 1:M
        phi_tilda(i,j) = exp((-(norm(centroids(i,:)-centroids(j,:)))^2)/widthParam);
    end
end


% estimating coefficients
if lambda ==0
    coeffs = pinv(designMat)*targets;
else
    coeffs = inv((designMat'*designMat)+(lambda*phi_tilda))*designMat'*targets;
end
