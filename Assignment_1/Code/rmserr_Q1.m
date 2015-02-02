function [rms_train,rms_test,rms_val] = rmserr_Q1(train,test,val,M,lambda)

coeffs = curve_fit(train,M,lambda);  
y1 = train(:,2);
y2 = polyval(coeffs,train(:,1));
[err,n] = sumsqr(y2-y1);
rms_train = sqrt(err);


y1 = test(:,2);
y2 = polyval(coeffs,test(:,1));
[err,n] = sumsqr(y2-y1);
rms_test = sqrt(err);

y1 = val(:,2);
y2 = polyval(coeffs,val(:,1));
[err,n] = sumsqr(y2-y1);
rms_val = sqrt(err);
