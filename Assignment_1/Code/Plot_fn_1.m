function Plot_fn_1 = Plot_fn_1(train,M,lambda,index)

coeffs = curve_fit(train,M,lambda);  
x = 0:.001:1;       
y1 = exp(cos(2*pi*x));
y2 = polyval(coeffs,x);

N = length(train);

% Change this line each time to give different names to the plots
if (index == 0)
    legend('t','f(x)','y(x,w)');
    plot(train(:,1),train(:,2),'go',x,y1,'b',x,y2,'r'), axis([0,1,0,3]);
    %title(strcat('Plot of approximated function and target function for N = '),int2str(N),' and M = ', int2str(M))
    
    a = strcat(('Plot of approximated and target function N = '),int2str(N), ' and M = ',int2str(M));
    
    title(a);
    xlabel('x (input variable)');
    ylabel('Model and Target output');
    
    legend('show');
    %saveas(fig1,strcat('Plots_1/Varying_M/VaryingM_N',int2str(length(train)),'M',int2str(M),'.png'));
    
end   
if(index == 1)
    fig1 = figure(1);

    plot(train(:,1),train(:,2),'go',x,y1,'b',x,y2,'r'), axis([0,1,0,3]);
    legend('t','f(x)','y(x,w)');
    
    %title(strcat('Plot of approximated function and target function for N = '),int2str(N),' and M = ', int2str(M))
    
    a = strcat(('Plot of approximated and target function N = '),int2str(N), ' and M = ',int2str(M));
    
    title(a);
    xlabel('x (input variable)');
    ylabel('Model and Target output');
    
    legend('show');
    saveas(fig1,strcat('Plots_1/Varying_M/VaryingM_N',int2str(length(train)),'M',int2str(M),'.png'));
    
end

if(index == 2)
    fig1 = figure(1);

    plot(train(:,1),train(:,2),'go',x,y1,'b',x,y2,'r'), axis([0,1,0,3]);
     a = strcat(('Plot of approximated and target function N = '),int2str(N), ' and M = ',int2str(M));
    
    title(a);
    xlabel('x (input variable)');
    ylabel('Model and Target output');
    
    legend('Data points','t','y(x,w)');
    saveas(fig1,strcat('Plots_1/Varying_N/VaryingN_N',int2str(length(train)),'M',int2str(M),'.png')); 
end

if (index == 3)
    fig1 = figure(1);

    plot(train(:,1),train(:,2),'go',x,y1,'b',x,y2,'r'), axis([0,1,0,3]);
    legend('Data points','t','y(x,w)');
    a = strcat(('Plot of approximated and target function N = '),int2str(N), ' and M = ',int2str(M),' for lambda = ',num2str(lambda));
    
    title(a);
    xlabel('x (input variable)');
    ylabel('Model and Target output');
    
    saveas(fig1,strcat('Plots_1/Varying_lambda/Varyinglambda_N',int2str(length(train)),'M',int2str(M),'lambda',num2str(lambda),'.png'));    
end


Plot_fn_1 = 0;

