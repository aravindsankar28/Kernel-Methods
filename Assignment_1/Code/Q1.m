M = 3;

% Polynomial curve fitting without regularization. - Acutally not needed
% now since regularization is done.

[coeffs,S] = polyfit(train(:,1),train(:,2),M);
y = polyval(coeffs,train(:,1));

% This is to plot the original curve 
x1 = 0:.01:1; 
y1 = exp(cos(2*pi*x1));

x2 = 0:.01:1; 

% Plots

% Plot showing the polynomial obtained on varying M ( lambda = 0).

lambda = 0.0;
M_values = [0,1,3,9,15];
for i = 1:length(M_values)
    coeffs = curve_fit(train,M_values(i),lambda);
    y2 = polyval(coeffs,x2);
    figure
    
    plot(train(:,1),train(:,2),'bo',x1,y1,'g',x2,y2,'r'), axis([0,1,0,3]);
end





mse = 0.5*sum( (y - train(:,2)).^2 );  
rmse = sqrt( 2*mse/length(y) );

%figure

