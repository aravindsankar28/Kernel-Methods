sigma = 0.1;
% 
% val_data = samplePoints(sigma,250);
% test_data = samplePoints(sigma,250);
% train_data = samplePoints(sigma,1000);
% 
% save('data.mat','train_data','val_data','test_data');
load('data.mat');
data_input = [train_data(:,1);val_data(:,1);test_data(:,1)];
data_target = [train_data(:,2);val_data(:,2);test_data(:,2)];

