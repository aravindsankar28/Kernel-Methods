function sampledPoints = samplePoints(sigma,N)

%N represents the number of points to sample
%sigma represents the stanard deviation of Gaussian noise

sampledPoints = zeros(N,2);

for i = 1:size(sampledPoints,1)
    x = rand();
    eps = normrnd(0,sigma);
    f = exp(cos(2*pi*x)) + eps;
    sampledPoints(i,1) = x;
    sampledPoints(i,2) = f;
end
   