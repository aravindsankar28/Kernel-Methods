function out = predictPerceptron(nets,test,size)


class_labels = zeros(size,4);

a = sim(nets{1},test');
b = sim(nets{2},test');
c = sim(nets{3},test');
d = sim(nets{4},test');
e = sim(nets{5},test');
f = sim(nets{6},test');

class_labels(:,1) = class_labels(:,1) + a';
class_labels(:,1) = class_labels(:,1) + b';
class_labels(:,1) = class_labels(:,1) + c';

class_labels(:,2) = class_labels(:,2) + (a' == 0);
class_labels(:,2) = class_labels(:,2) + d';
class_labels(:,2) = class_labels(:,2) + e';

class_labels(:,3) = class_labels(:,3) + (b' == 0);
class_labels(:,3) = class_labels(:,3) + (d' == 0);
class_labels(:,3) = class_labels(:,3) + f';

class_labels(:,4) = class_labels(:,4) + (c' == 0);
class_labels(:,4) = class_labels(:,4) + (e' == 0);
class_labels(:,4) = class_labels(:,4) + (f' == 0);


labels = zeros(size,1);
for i = 1:size
   [val,idx] = max(class_labels(i,:));
   labels(i) = idx;
end


out = labels;
