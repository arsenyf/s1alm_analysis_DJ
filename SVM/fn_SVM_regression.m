function [t,perf_t,smallest_set_num] = fn_SVM_regression(key)
perf_t=[];
t=[];
smallest_set_num=0;

% rel = (EXP.Session  & EPHYS.Unit & ANL.IncludeUnit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"') * EXP.SessionID * (EPHYS.UnitPosition & "brain_area='ALM'");

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
rel_video=(  (ANL.Video1stLickTrialNormalized&k_video)* (EXP.BehaviorTrial & 'early_lick="no early"') & key);
TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));

analyzed_trials=  [TONGUE.trial];

%
% if key.flag_include_distractor_trials ==1
%     tr_left_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="left"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%     tr_right_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="right"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%
%     tr_left_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="left"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%     tr_right_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="right"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
% elseif key.flag_include_distractor_trials ==0
%     tr_left_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="l"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%     tr_right_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="r"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%
%     tr_left_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="l"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
%     tr_right_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="r"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
% end




time_window_wo_NANs= psth_t_vector>-2.5 & psth_t_vector<2;
cells_trials=squeeze(mean(psth_t_u_tr(time_window_wo_NANs,:,analyzed_trials),1));
num_analyzed_trials = numel(analyzed_trials);

stable_cells = sum(isnan(cells_trials),2)<=num_analyzed_trials/4;
psth_t_u_tr = psth_t_u_tr(:,stable_cells,analyzed_trials);
if sum(stable_cells)<5
    return
end





% t=-3:0.1:1;
t=[-3,0,0.2,1];

t_wind=0.2;

Y_all=TONGUE.lick_vel_linear;
idx_all_trials=1:1:numel(Y_all);

% idx_left=(Y_all<0.5);
idx_trials=idx_all_trials;
% Y_all=Y_all(idx_left);
idx_all_trials=1:1:numel(Y_all);
for i_t=1:1:numel(t)
    t(i_t);
    ix_t = psth_t_vector >= t(i_t)-t_wind & psth_t_vector < t(i_t);
    
    PV_at_t= squeeze(nanmean(psth_t_u_tr( ix_t,:,idx_trials), 1))';
    
    X_all=PV_at_t;
    X_all(isnan(X_all))=0;
%     X_all = zscore(X_all);
    perf=[];
    
    for i_test = 1:1:100
        idx_train_trials=randsample(idx_trials,ceil(numel(idx_trials)/3));
        
        X_train=X_all(idx_train_trials,:);
        Y_train=Y_all(idx_train_trials);
        mdl = fitrsvm(X_train,Y_train,'Standardize',true,'KernelFunction','gaussian','KernelScale','auto');
        idx_test_trials=~ismember(idx_trials,idx_train_trials);
        yfit = predict(mdl,X_all(idx_test_trials,:));
        perf(i_test)=nanmean(1-(abs(Y_all(idx_test_trials)-yfit)));
        
    end
    
%     for i_test = 1:1:numel(idx_all_trials)
%         idx_train_trials=(idx_all_trials~=i_test);
%         X_train=X_all(idx_train_trials,:);
%         Y_train=Y_all(idx_train_trials);
%         mdl = fitrsvm(X_train,Y_train,'Standardize',true,'KernelFunction','gaussian','KernelScale','auto');
% %                 mdl = fitrsvm(X_train,Y_train,'Standardize',true);
% % mdl = fitlm(X_train,Y_train,'RobustOpts','on');
%         yfit(i_test) = predict(mdl,X_all(i_test,:));
%     end

%     perf=1-(abs(Y_all-yfit'))
%     plot(Y_all,yfit,'.')
    perf_rep_t(i_t) = mean(perf);
    
    %         perf_t.m (i_t) = mean(perf);
    %         perf_t.std (i_t) = std(perf);
    %         perf_t.stem (i_t) = std(perf)./sqrt(numel(perf));
    
end
perf_rep_t

% plot(t,perf_t.m)