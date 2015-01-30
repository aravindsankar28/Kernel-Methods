function coeffs = curve_fit(train,M,lambda)

if nargin == 2
    coeffs = polyfit(train(:,1),train(:,2),M-1);
end


if nargin > 2
    x = zeros(size(train,1),M);

    for i = 1:size(train,1)
        for j = 1:M
            x(i,j) = train(i,1)^(M+1-j);
        end
    end

    %The final result has the coefficients in the reversed order, first x^M,
    %then x^M-1 and so on till the constant term
    w = ridge(train(:,2),x,lambda,0);
    w0 = w(1);
    w = vec2mat(w,size(w,1));
    coeffs = [w(2:size(w,2)),w0];
end 