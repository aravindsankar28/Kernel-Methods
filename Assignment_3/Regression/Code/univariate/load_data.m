% sigma = 0.1; 
% val_data = samplePoints(sigma,100);
% test_data = samplePoints(sigma,50);
% train_data = samplePoints(sigma,250);
% save('data.mat','train_data','val_data','test_data');


load('data.mat');
%data_input = [train_data(:,1);val_data(:,1);test_data(:,1)];
%data_target = [train_data(:,2);val_data(:,2);test_data(:,2)];

data = [train_data; val_data; test_data];

train = train_data(:,1);
val = val_data(:,1);
test = test_data(:,1);

target_train = train_data(:,2);
target_val = val_data(:,2);
target_test = test_data(:,2);
plot(data(:,1),data(:,2),'b.');

a = title('Data Plot');
set(a,'Interpreter','latex');
b = xlabel('x');
ylabel('f(x)');
set(b,'Interpreter','latex');
