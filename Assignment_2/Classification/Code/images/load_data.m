load('../../Data/images/CompleteData.mat');
class1_data = CompleteData{9};
CompleteData(9,2)

class2_data = CompleteData{4};
CompleteData(4,2)

class3_data = CompleteData{11};
CompleteData(11,2)

class4_data = CompleteData{10};
CompleteData(10,2)

class5_data = CompleteData{1};
CompleteData(1,2)


data = [class1_data; class2_data; class3_data; class4_data ; class5_data ];
target_data = [ones(length(class1_data),1); ones(length(class2_data),1)*2; ones(length(class3_data),1)*3; ones(length(class4_data),1)*4; ones(length(class5_data),1)*5];


