function [rms_train,rms_test,rms_val] = rmserr_Q1_M(train,test,val,M,lambda_values)
N = size(train);
N = N(1);
N
x = lambda_values(1);
rms_val = 10000;
size(lambda_values,2)
for i = 1:size(lambda_values,2)
    i
    coeffs = curve_fit(train,M,lambda_values(i)); 
    y1 = val(:,2);
    y2 = polyval(coeffs,val(:,1));
    [err,n] = sumsqr(y2-y1);
    if sqrt(err/N) < rms_val
        rms_val = sqrt(err/N);
        x = lambda_values(i);
        x
    end
end
coeffs = curve_fit(train,M,x); 

y1 = train(:,2);
y2 = polyval(coeffs,train(:,1));
[err,n] = sumsqr(y2-y1);
rms_train = sqrt(err/N);


y1 = test(:,2);
y2 = polyval(coeffs,test(:,1));
[err,n] = sumsqr(y2-y1);
rms_test = sqrt(err/N);


