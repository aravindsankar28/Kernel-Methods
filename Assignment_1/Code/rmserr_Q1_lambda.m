function [rms_train,rms_test,rms_val] = rmserr_Q1_lambda(train,test,val,M_values,lambda)

 
N = size(val,1);
x = M_values(1);
rms_val = 10000;
size(M_values,2)
for i = 1:size(M_values,2)
    coeffs = curve_fit(train,M_values(i),lambda); 
    y1 = val(:,2);
    y2 = polyval(coeffs,val(:,1));
    [err,n] = sumsqr(y2-y1);
    if sqrt(err/N) < rms_val
        rms_val = sqrt(err/N);
        x = M_values(i);
    end
end
%x

coeffs = curve_fit(train,x,lambda); 
%lambda
%coeffs
N = size(train,1);
y1 = train(:,2);
y2 = polyval(coeffs,train(:,1));
%y2
[err,n] = sumsqr(y2-y1);
rms_train = sqrt(err/N);

N = size(test,1);
y1 = test(:,2);
y2 = polyval(coeffs,test(:,1));
[err,n] = sumsqr(y2-y1);
rms_test = sqrt(err/N);


