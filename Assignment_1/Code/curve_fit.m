function coeffs = curve_fit(train,M,lambda)

x = zeros(size(train,1),M+1);

for i = 1:size(train,1)
    for j = 1:(M+1)
        x(i,j) = train(i,1)^(M+1-j);
    end
end


b = ridge(train(:,2),x,lambda,0);
% Note that b(1) includes a constant term in itself.. So we add it our
% term.
coeffs = b(2:length(b))';
coeffs(end) = coeffs(end) + b(1);