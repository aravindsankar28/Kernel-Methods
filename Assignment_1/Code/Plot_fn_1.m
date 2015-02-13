function Plot_fn_1 = Plot_fn_1(train,M,lambda,index,val,test)

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
    %fig1 = figure(1);

    %plot(train(:,1),train(:,2),'go',x,y1,'b',x,y2,'r'), axis([0,1,0,3]);
    %legend('t','f(x)','y(x,w)');
    %a = strcat(('Plot of approximated and target function N = '),int2str(N), ' and M = ',int2str(M));
    %title(a);
    %xlabel('x (input variable)');
    %ylabel('Model and Target output');
    
    %legend('show');
    b = strcat('Scatter plot of model output Vs target output for N = ',int2str(N),' and M = ',int2str(M));
    scatter(train(:,2),polyval(coeffs,train(:,1)),'ko','filled'); 
    %scatter(polyval(coeffs,train(:,1)),train(:,2),'ko','filled'); 
    xlabel('Target output');
    ylabel('Model output');
    axis equal;
    %legend('Train');
    title(b);
    fig1 = figure(1);
    %saveas(fig1,strcat('Plots_1/Scatter/VaryingM/VaryingM_N',int2str(length(train)),'M',int2str(M),'.png'));
    %hold on;
    %scatter(polyval(coeffs,val(:,1)),val(:,2),'ro','filled');
    
    %hold on;
    %scatter(polyval(coeffs,test(:,1)),test(:,2),'bo','filled');
    
    
    %scatter(test(:,2),polyval(coeffs,test(:,1)),'bo','filled');
    %fig1 = figure(1);
    %hold off;
    %legend('Test');
    %legend('show');
    %xlabel('Target output');
    %ylabel('Model output');
    %b = strcat('Scatter plot of model output Vs target output for N = ',int2str(N),' and M = ',int2str(M),' on test data');
    %title(b);
    %saveas(fig1,strcat('Plots_1/Scatter/VaryingM/VaryingM_N',int2str(length(train)),'M',int2str(M),'_test.png'));
    
end

if(index == 2)
    fig1 = figure(1);
% 
%     plot(train(:,1),train(:,2),'go',x,y1,'b',x,y2,'r'), axis([0,1,0,3]);
%      a = strcat(('Plot of approximated and target function N = '),int2str(N), ' and M = ',int2str(M));
%     
%     title(a);
%     xlabel('x (input variable)');
%     ylabel('Model and Target output');
%     
%     legend('Data points','t','y(x,w)');

    b = strcat('Scatter plot of model output Vs target output for N = ',int2str(N),' and M = ',int2str(M));
    %scatter(polyval(coeffs,train(:,1)),train(:,2),'ko','filled'); 
    scatter(train(:,2),polyval(coeffs,train(:,1)),'ko','filled'); 
    xlabel('Target output');
    ylabel('Model output');
    title(b);
    saveas(fig1,strcat('Plots_1/Scatter/VaryingN/VaryingN_N',int2str(length(train)),'M',int2str(M),'.png')); 
end

if (index == 3)
    fig1 = figure(1);

%     plot(train(:,1),train(:,2),'go',x,y1,'b',x,y2,'r'), axis([0,1,0,3]);
%     legend('Data points','t','y(x,w)');
%     a = strcat(('Plot of approximated and target function N = '),int2str(N), ' and M = ',int2str(M),' for lambda = ',num2str(lambda));
%     
%     title(a);
%     xlabel('x (input variable)');
%     ylabel('Model and Target output');

    b = strcat('Scatter plot of model output Vs target output for N = ',int2str(N),' and M = ',int2str(M),' lambda = ',num2str(lambda));
    %scatter(polyval(coeffs,train(:,1)),train(:,2),'ko','filled'); 
    scatter(train(:,2),polyval(coeffs,train(:,1)),'ko','filled'); 
    xlabel('Target output');
    ylabel('Model output');
    title(b);
    
    saveas(fig1,strcat('Plots_1/Scatter/Varying_lambda/Varyinglambda_N',int2str(length(train)),'M',int2str(M),'lambda',num2str(lambda),'.png'));    
end



Plot_fn_1 = 0;

