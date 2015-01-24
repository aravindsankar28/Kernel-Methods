sigma = 0.1; % Need to set this

train = zeros(100,2);
val = zeros(50,2);
test = zeros(50,2);

for i = 1:size(train,1)
    x = rand();
    eps = normrnd(0,sigma);
    f = exp(cos(2*pi*x)) + eps;
    train(i,1) = x;
    train(i,2) = f;
end
   


for i = 1:size(val,1)
    x = rand();
    eps = normrnd(0,sigma);
    f = exp(cos(2*pi*x)) + eps;
    val(i,1) = x;
    val(i,2) = f;
end
   


for i = 1:size(test,1)
    x = rand();
    eps = normrnd(0,sigma);
    f = exp(cos(2*pi*x)) + eps;
    test(i,1) = x;
    test(i,2) = f;
end
   
