load('../../Data/images/CompleteData.mat');
class1_data = CompleteData{9};
class1_data = class1_data(1:140,:);
CompleteData(9,2)

class2_data = CompleteData{4};
class2_data = class2_data(1:140,:);
CompleteData(4,2)

class3_data = CompleteData{11};
class3_data = class3_data(1:140,:);
CompleteData(11,2)

class4_data = CompleteData{10};
class4_data = class4_data(1:140,:);
CompleteData(10,2)

class5_data = CompleteData{1};
class5_data = class5_data(1:140,:);
CompleteData(1,2)


data = [class1_data; class2_data; class3_data; class4_data ; class5_data ];
target_data = [ones(length(class1_data),1); ones(length(class2_data),1)*2; ones(length(class3_data),1)*3; ones(length(class4_data),1)*4; ones(length(class5_data),1)*5];

oneofk_target = zeros(length(data),5);
x = 0;
for i = 1:length(class1_data)
    oneofk_target(x+i,1) = 1;
end
x = x+length(class1_data);
for i = 1:length(class2_data)
    oneofk_target(x+i,2) = 1;
end
x = x+length(class2_data);
for i = 1:length(class3_data)
    oneofk_target(x+i,3) = 1;
end
x = x+length(class3_data);
for i = 1:length(class4_data)
    oneofk_target(x+i,4) = 1;
end
x = x+length(class4_data);
for i = 1:length(class5_data)
    oneofk_target(x+i,5) = 1;
end
