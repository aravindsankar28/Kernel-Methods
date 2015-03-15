load_data;

M_values = [2,5,10,15,50,100,200];  % no of basis functions
lambda_values = [10^(-6),10^(-4),10^(-2),1,10,100,1000,10000]; % regularization parameter

peformances = zeros(56,5);

k = 1;
for i = 1:length(M_values)
    M = M_values(i);
    for j = 1:length(lambda_values)
        lambda = lambda_values(j);
        [coeffs,designMat,centroids,widthParam,phi_tilda] = surface_fit(train_data(:,1),train_data(:,2),length(train_data),M,lambda);
        model_output_train = designMat*coeffs;
        target_output_train = train_data(:,2);
        
        
        % constructing design matrix for val set and evaluating
        % performance.
        designMat_val = zeros(size(val_data,1),M);
        for i1=1:size(val_data,1)
            for j1=1:M
                designMat_val(i1,j1) = exp((-norm(val_data(i1,1)-centroids(j1,:))^2)/widthParam);
            end
        end
        model_output_val = designMat_val*coeffs;
        target_output_val = val_data(:,2);


        % constructing design matrix for test set and evaluating
        % performance.
        designMat_test = zeros(size(test_data,1),M);
        for i1=1:size(test_data,1)
            for j1=1:M
                designMat_test(i1,j1) = exp((-norm(test_data(i1,1)-centroids(j1,:))^2)/widthParam);
            end
        end
        model_output_test = designMat_test*coeffs;
        target_output_test = test_data(:,2);
        
        
        train_performance = sumsqr(target_output_train-model_output_train)/length(target_output_train);
        val_performance = sumsqr(target_output_val-model_output_val)/length(target_output_val);
        test_performance = sumsqr(target_output_test-model_output_test)/length(target_output_test);
        
        performances(k,:) = [M,lambda,train_performance,val_performance,test_performance];
        k = k +1;
    end
end


[minval,idx] = min(performances(1:48,4));
best_M = performances(idx,1)
best_lambda = performances(idx,2)




