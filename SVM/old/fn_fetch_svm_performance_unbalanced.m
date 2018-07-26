function svm_performance = fn_fetch_svm_performance_unbalanced(key,rel)

% Left ALM
key.brain_area = 'ALM';
key.hemisphere = 'left';
num=1;
svm_performance(num).all = 100*cell2mat(fetchn(rel & key,'svm_performance_time'));
if ~isempty(svm_performance(num).all)
    svm_performance(num).all = svm_performance(num).all - mean(svm_performance(num).all(:,1:2),2)+50;
    svm_performance(num).m = mean(svm_performance(num).all,1);
    svm_performance(num).std = std(svm_performance(num).all,[],1);
    svm_performance(num).stem = svm_performance(num).std./sqrt(size(svm_performance(num).all,1));
    svm_performance(num).brain_area = key.brain_area;
    svm_performance(num).hemisphere = key.hemisphere;
end

%Right ALM
key.brain_area = 'ALM';
key.hemisphere = 'right';
num=2;
svm_performance(num).all = 100*cell2mat(fetchn(rel & key,'svm_performance_time'));
if ~isempty(svm_performance(num).all)
    svm_performance(num).all = svm_performance(num).all - mean(svm_performance(num).all(:,1:2),2)+50;
    svm_performance(num).m = mean(svm_performance(num).all,1);
    svm_performance(num).std = std(svm_performance(num).all,[],1);
    svm_performance(num).stem = svm_performance(num).std./sqrt(size(svm_performance(num).all,1));
    svm_performance(num).brain_area = key.brain_area;
    svm_performance(num).hemisphere = key.hemisphere;
end

%Left vS1
key.brain_area = 'vS1';
key.hemisphere = 'left';
num=3;
svm_performance(num).all = 100*cell2mat(fetchn(rel & key,'svm_performance_time'));
if ~isempty(svm_performance(num).all)
    svm_performance(num).all = svm_performance(num).all - mean(svm_performance(num).all(:,1:2),2)+50;
    svm_performance(num).m = mean(svm_performance(num).all,1);
    svm_performance(num).std = std(svm_performance(num).all,[],1);
    svm_performance(num).stem = svm_performance(num).std./sqrt(size(svm_performance(num).all,1));
    svm_performance(num).brain_area = key.brain_area;
    svm_performance(num).hemisphere = key.hemisphere;
end