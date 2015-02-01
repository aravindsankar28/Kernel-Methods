function Plot_fn_1 = Plot_fn_1(train,M,lambda,index)

coeffs = curve_fit(train,M,lambda);  
x = 0:.001:1;       
y1 = exp(cos(2*pi*x));
y2 = polyval(coeffs,x);
fig1 = figure;

plot(train(:,1),train(:,2),'go',x,y1,'b',x,y2,'r'), axis([0,1,0,3]);


% Change this line each time to give different names to the plots

if(index == 1)
    legend('Data points','t','y(x,w)');
    saveas(fig1,strcat('Plots_1/Varying_M/VaryingM_N',int2str(length(train)),'M',int2str(M),'.png'));
end

if(index == 2)
    legend('Data points','t','y(x,w)');
    saveas(fig1,strcat('Plots_1/Varying_N/VaryingN_N',int2str(length(train)),'M',int2str(M),'.png')); 
end

if (index == 3)
    legend('Data points','t','y(x,w)');
    saveas(fig1,strcat('Plots_1/Varying_lambda/Varyinglambda_N',int2str(length(train)),'M',int2str(M),'lambda',num2str(lambda),'.png'));    
end


Plot_fn = 0;

