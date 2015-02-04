function [rms_train,rms_test,rms_val] = rmserr_Q2_M(train,test,val,M,lambda_values)

bestLambda = lambda_values(1);
rms_val = 10000;

for i = 1:size(lambda_values,2)
    [coeffs,designMat,centroids,widthParam] = surface_fit(train,size(train,1),M,lambda_values(i));
    
    % constructing design matrix for val set
    designMat = zeros(size(val,1),M);
    for i1=1:size(val,1)
        for j=1:M
            designMat(i1,j) = exp(-norm(val(i1,1:2)-centroids(j,:))^2)/widthParam(j,1);
        end
    end
    model_output = designMat*coeffs;
    target_output = val(:,3);

    [err,n] = sumsqr(target_output-model_output);
    if sqrt(err/size(val,1)) < rms_val
        rms_val = sqrt(err/size(val,1));
        bestLambda = lambda_values(i);
    end
end

[coeffs,designMat,centroids,widthParam] = surface_fit(train,size(train,1),M,bestLambda);
model_output = designMat*coeffs;
target_output = train(:,3);
[err,n] = sumsqr(target_output-model_output);
rms_train = sqrt(err/size(train,1));

% constructing design matrix for test set
designMat = zeros(size(test,1),M);
for i1=1:size(test,1)
    for j=1:M
        designMat(i1,j) = exp(-norm(test(i1,1:2)-centroids(j,:))^2)/widthParam(j,1);
    end
end
model_output = designMat*coeffs;
target_output = test(:,3);
[err,n] = sumsqr(target_output-model_output);
rms_test = sqrt(err/size(test,1));


