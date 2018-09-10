function [t, perf_rep_t_left, perf_rep_t_right] = fn_SVM_tongue_binary(key)
t=[];
perf_rep_t_left=[];
perf_rep_t_right=[];

% rel = (EXP.Session  & EPHYS.Unit & ANL.IncludeUnit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"') * EXP.SessionID * (EPHYS.UnitPosition & "brain_area='ALM'");
if strcmp(key.outcome,'all')
    key=rmfield(key,'outcome');
end
psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');

%
% session_uid = fetchn(rel,'session_uid');
% key.session_uid=session_uid(1);
% unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & key & 'unit_quality="ok" or unit_quality="good"', 'unit', 'ORDER BY unit_uid');
unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & key, 'unit', 'ORDER BY unit_uid');

if isempty(unit_num)
    return
end
psth_t_u_tr = fetch1(ANL.PSTHMatrix * EXP.SessionID & key , 'psth_t_u_tr');
psth_t_u_tr =psth_t_u_tr(:,unit_num,:);



k_video.tongue_estimation_type='tip';

if key.flag_use_basic_trials==1
    rel_video=(  (ANL.Video1stLickTrialNormalized&k_video)*   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1'))* (EXP.BehaviorTrial & 'early_lick="no early"') & key);
else
    rel_video=(  (ANL.Video1stLickTrialNormalized&k_video)* (EXP.BehaviorTrial & 'early_lick="no early"') & key);
end

TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));

analyzed_trials=  [TONGUE.trial];

time_window_wo_NANs= psth_t_vector>-3.5 & psth_t_vector<2;
cells_trials=squeeze(mean(psth_t_u_tr(time_window_wo_NANs,:,analyzed_trials),1));
num_analyzed_trials = numel(analyzed_trials);

stable_cells = sum(isnan(cells_trials),2)<=num_analyzed_trials/4;
psth_t_u_tr = psth_t_u_tr(:,stable_cells,analyzed_trials);
if sum(stable_cells)<5
    return
end



% t=-3:0.1:2;
t=-3.0:0.1:2;

t_step=0.25;

V=TONGUE.lick_horizoffset_relative;
analyzed_trials_renumbered=1:1:numel(analyzed_trials);


tr.left.all=analyzed_trials_renumbered(V<0.5);
Vmedian=median(V(tr.left.all));
tr.left.edge=tr.left.all(V(tr.left.all)<Vmedian);
tr.left.center=tr.left.all(V(tr.left.all)>=Vmedian);

tr.right.all=analyzed_trials_renumbered(V>=0.5);
Vmedian=median(V(tr.right.all));
tr.right.edge=tr.right.all(V(tr.right.all)>=Vmedian);
tr.right.center=tr.right.all(V(tr.right.all)<Vmedian);


if numel(tr.left.all)>10
% left trials
tr_edge=tr.left.edge;
tr_center=tr.left.center;
Y(1:numel(tr_edge),1)={'edge'}';
Y(numel(tr_edge)+1:numel(tr_edge)+numel(tr_center))={'center'}';
for i_t=1:1:numel(t)
    t(i_t);
    ix_t = psth_t_vector >= t(i_t)-t_step & psth_t_vector < t(i_t);
    psth1= squeeze(nanmean(psth_t_u_tr( ix_t,:, tr_edge), 1))';
    psth2 = squeeze(nanmean(psth_t_u_tr( ix_t,:, tr_center), 1))';
    X=[psth1;psth2];
    X(isnan(X))=0;
    Inds=1:1:numel(Y);
    for i_test = 1:1:numel(Y)
        trainInds=(Inds~=i_test);
        Xtrain = X(trainInds,:);
        Ytrain = Y(trainInds);
        CVSVMModel = fitcsvm(Xtrain,Ytrain,'ClassNames',{'edge','center'},...
            'Standardize',true, 'OutlierFraction',0.05);
        [predicted_label,~] = predict(CVSVMModel,X(i_test,:));
        perf(i_test) =     sum(strcmp(Y(i_test),predicted_label));
    end
    perf_rep_t_left(i_t) = mean(perf);
end
else
    perf_rep_t_left=t+NaN;
end

if numel(tr.right.all)>10 
clear X Y
perf=[];
% right trials
% left trials
tr_edge=tr.right.edge;
tr_center=tr.right.center;
Y(1:numel(tr_edge),1)={'edge'}';
Y(numel(tr_edge)+1:numel(tr_edge)+numel(tr_center))={'center'}';
for i_t=1:1:numel(t)
    t(i_t);
    ix_t = psth_t_vector >= t(i_t)-t_step & psth_t_vector < t(i_t);
    psth1= squeeze(nanmean(psth_t_u_tr( ix_t,:, tr_edge), 1))';
    psth2 = squeeze(nanmean(psth_t_u_tr( ix_t,:, tr_center), 1))';
    X=[psth1;psth2];
    X(isnan(X))=0;
    Inds=1:1:numel(Y);
    for i_test = 1:1:numel(Y)
        trainInds=(Inds~=i_test);
        Xtrain = X(trainInds,:);
        Ytrain = Y(trainInds);
        CVSVMModel = fitcsvm(Xtrain,Ytrain,'ClassNames',{'edge','center'},...
            'Standardize',true,'OutlierFraction',0.05);
        [predicted_label,~] = predict(CVSVMModel,X(i_test,:));
        perf(i_test) =     sum(strcmp(Y(i_test),predicted_label));
    end
    perf_rep_t_right(i_t) = mean(perf);
end
else
    perf_rep_t_right=t+NaN;
end


end









% % left trials
% Y(1:numel(tr.left.edge),1)={'edge'}';
% Y(numel(tr.left.edge)+1:numel(tr.left.center)+numel(tr.left.center))={'center'}';
% for i_t=1:1:numel(t)
%     t(i_t);
%     ix_t = psth_t_vector >= t(i_t)-t_step & psth_t_vector < t(i_t);
%     psth1= squeeze(nanmean(psth_t_u_tr( ix_t,:, tr.left.edge), 1))';
%     psth2 = squeeze(nanmean(psth_t_u_tr( ix_t,:, tr.left.center), 1))';
%     X=[psth1;psth2];
%     X(isnan(X))=0;
%     for i_rep = 1:1:100
%         CVSVMModel = fitcsvm(X,Y,'Holdout',0.5,'ClassNames',{'edge','center'},...
%             'Standardize',true);
%         CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
%         testInds = test(CVSVMModel.Partition);   % Extract the test indices
%         XTest = X(testInds,:);
%         YTest = Y(testInds,:);
%         [predicted_label,score] = predict(CompactSVMModel,XTest);
%         perf(i_rep) =     sum(strcmp(YTest,predicted_label))./sum(testInds);
%     end
%     perf_rep_t_left(i_t) = mean(perf);
% end
%
%
% clear X Y
% perf=[];
% % right trials
% Y(1:numel(tr.left.edge),1)={'edge'}';
% Y(numel(tr.left.edge)+1:numel(tr.left.center)+numel(tr.left.center))={'center'}';
% for i_t=1:1:numel(t)
%     t(i_t);
%     ix_t = psth_t_vector >= t(i_t)-t_step & psth_t_vector < t(i_t);
%     psth1= squeeze(nanmean(psth_t_u_tr( ix_t,:, tr.left.edge), 1))';
%     psth2 = squeeze(nanmean(psth_t_u_tr( ix_t,:, tr.left.center), 1))';
%     X=[psth1;psth2];
%     X(isnan(X))=0;
%     for i_rep = 1:1:100
%         CVSVMModel = fitcsvm(X,Y,'Holdout',0.5,'ClassNames',{'edge','center'},...
%             'Standardize',true);
%         CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
%         testInds = test(CVSVMModel.Partition);   % Extract the test indices
%         XTest = X(testInds,:);
%         YTest = Y(testInds,:);
%         [predicted_label,score] = predict(CompactSVMModel,XTest);
%         perf(i_rep) =     sum(strcmp(YTest,predicted_label))./sum(testInds);
%     end
%     perf_rep_t_right(i_t) = mean(perf);
% end




