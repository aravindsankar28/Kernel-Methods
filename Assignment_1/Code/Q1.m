% Parameters
% sigma       - standard deviation of Gaussian noise
% N           - number of points to sample
% M           - model complexity
% lambda      - array of values to test for regularization

lambda = [0,10^(-6),10^(-5),10^(-4),10^(-3),10^(-2),10^(-1),1,2,5];
sigma = 0.1;

validationSet = samplePoints(sigma,50);
testSet = samplePoints(sigma,50);

train_100 = samplePoints(sigma,100);
train_200 = samplePoints(sigma,200);
train_1000 = samplePoints(sigma,1000);

%fn = @(x) exp(cos(2*pi*x));
%fplot(fn,[0,1]);

lambda = 0.0;
M_values = [0,1,3,9,15,200];
for i = 1:length(M_values)
    
    coeffs = curve_fit(train_100,M_values(i),lambda);  
    x = 0:.001:1;     
    y1 = exp(cos(2*pi*x1));
    y2 = polyval(coeffs,x1);
    figure
    
    plot(train_100(:,1),train_100(:,2),'go',x,y1,'b',x,y2,'r'), axis([0,1,0,3]);
end

%coeffs = curve_fit([0:0.1:1],3);
%figure
%plot([0:0.1:1],polyval(coeffs,[0:0.1:1]));

%{
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
%}
