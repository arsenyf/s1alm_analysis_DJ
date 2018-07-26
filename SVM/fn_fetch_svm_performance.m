function svm_performance = fn_fetch_svm_performance(key,rel, smooth_flag)
smooth_bins=3;
% Left ALM
key.brain_area = 'ALM';
key.hemisphere = 'left';
num=1;
svm_performance(num).all = 100*cell2mat(fetchn(rel & key,'svm_performance_time'));
if smooth_flag ==1
    svm_performance(num).all = movmean(svm_performance(num).all ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
end
svm_performance(num).m = mean(svm_performance(num).all,1);
svm_performance(num).std = std(svm_performance(num).all,[],1);
svm_performance(num).stem = svm_performance(num).std./sqrt(size(svm_performance(num).all,1));
svm_performance(num).brain_area = key.brain_area;
svm_performance(num).hemisphere = key.hemisphere;

%Right ALM
key.brain_area = 'ALM';
key.hemisphere = 'right';
num=2;
svm_performance(num).all = 100*cell2mat(fetchn(rel & key,'svm_performance_time'));
if smooth_flag ==1
    svm_performance(num).all = movmean(svm_performance(num).all ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
end
svm_performance(num).m = mean(svm_performance(num).all,1);
svm_performance(num).std = std(svm_performance(num).all,[],1);
svm_performance(num).stem = svm_performance(num).std./sqrt(size(svm_performance(num).all,1));
svm_performance(num).brain_area = key.brain_area;
svm_performance(num).hemisphere = key.hemisphere;

%Left vS1
key.brain_area = 'vS1';
key.hemisphere = 'left';
num=3;
svm_performance(num).all = 100*cell2mat(fetchn(rel & key,'svm_performance_time'));
if smooth_flag ==1
    svm_performance(num).all = movmean(svm_performance(num).all ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
end
svm_performance(num).m = mean(svm_performance(num).all,1);
svm_performance(num).std = std(svm_performance(num).all,[],1);
svm_performance(num).stem = svm_performance(num).std./sqrt(size(svm_performance(num).all,1));
svm_performance(num).brain_area = key.brain_area;
svm_performance(num).hemisphere = key.hemisphere;