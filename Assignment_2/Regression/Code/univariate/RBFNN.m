load_data;

net = newrb(train(:,1)',train(:,2)',0.0001,1.0,100);

Y = sim(net,0:0.01:1);

scatter(0:0.01:1,Y);
figure;
scatter(train(:,1),train(:,2));
view(net);