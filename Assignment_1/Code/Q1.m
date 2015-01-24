%parameters
train_sigma = 0.1;
N = 200;
M = 5;
%lambda is an array of values to test for regularization
lambda = [0,10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),1,2,5];



[train,val,test] = datagen(train_sigma,N);


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

