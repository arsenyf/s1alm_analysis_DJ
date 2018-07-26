function [t,perf_t,smallest_set_num] = fn_SVM_decoder(key)
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

if key.flag_include_distractor_trials ==1
    tr_left_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="left"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
    tr_right_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="right"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
    
    tr_left_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="left"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
    tr_right_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_instruction ="right"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
elseif key.flag_include_distractor_trials ==0
    tr_left_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="l"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
    tr_right_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="r"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
    
    tr_left_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="l"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
    tr_right_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & key & 'trial_type_name ="r"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');
end



% analyzed_trials=  [tr_left_hit;tr_right_miss;tr_right_hit;tr_left_miss];
analyzed_trials=  [tr_left_hit;tr_right_hit];

time_window_wo_NANs= psth_t_vector>-2 & psth_t_vector<0;
cells_trials=squeeze(mean(psth_t_u_tr(time_window_wo_NANs,:,analyzed_trials),1));
num_analyzed_trials = numel(analyzed_trials);

stable_cells = sum(isnan(cells_trials),2)<=num_analyzed_trials/4;
psth_t_u_tr = psth_t_u_tr(:,stable_cells,:);
if sum(stable_cells)<5
    return
end

for i_subsample = 1:1:20
%         i_subsample
%     smallest_set_num = min([numel(tr_left_hit)+numel(tr_right_miss),numel(tr_right_hit)+numel(tr_left_miss)]);
        smallest_set_num = min([numel(tr_left_hit),numel(tr_right_hit)]);

    if smallest_set_num<5
        return
    end
    
%     left=  [datasample([tr_left_hit;tr_right_miss],smallest_set_num,'Replace',false)];
%     right= [datasample([tr_right_hit;tr_left_miss],smallest_set_num,'Replace',false)];
    left=  [datasample([tr_left_hit],smallest_set_num,'Replace',false)];
    right= [datasample([tr_right_hit],smallest_set_num,'Replace',false)];

    
    t=-3.5:0.1:1;
    t_step=0.2;
    
    Y(1:numel(left),1)={'left'}';
    Y(numel(left)+1:numel(left)+numel(right))={'right'}';
    
    for i_t=1:1:numel(t)
        t(i_t);
        ix_t = psth_t_vector >= t(i_t)-t_step & psth_t_vector < t(i_t);
        
        psth_u_tr_left= squeeze(nanmean(psth_t_u_tr( ix_t,:, left), 1))';
        psth_u_tr_right = squeeze(nanmean(psth_t_u_tr( ix_t,:, right), 1))';
        
        X=[psth_u_tr_left;psth_u_tr_right];
        X(isnan(X))=0;
        
        % load fisheriris
        % inds = ~strcmp(species,'setosa');
        % X = meas(inds,3:4);
        % y = species(inds);
        %
        % SVMModel = fitcsvm(X,Y)
        %
        % classOrder = SVMModel.ClassNames
        %
        % sv = SVMModel.SupportVectors;
        % figure
        % gscatter(X(:,1),X(:,2),Y)
        % hold on
        % plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
        % legend('versicolor','virginica','Support Vector')
        % hold off
        
        for i_rep = 1:1:50
            CVSVMModel = fitcsvm(X,Y,'Holdout',0.2,'ClassNames',{'right','left'},...
                'Standardize',true);
            CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
            testInds = test(CVSVMModel.Partition);   % Extract the test indices
            XTest = X(testInds,:);
            YTest = Y(testInds,:);
            [predicted_label,score] = predict(CompactSVMModel,XTest);
            perf(i_rep) =     sum(strcmp(YTest,predicted_label))./sum(testInds);
        end
        perf_rep_t(i_subsample,i_t) = mean(perf);
        
        %         perf_t.m (i_t) = mean(perf);
        %         perf_t.std (i_t) = std(perf);
        %         perf_t.stem (i_t) = std(perf)./sqrt(numel(perf));
        
    end
end
perf_t = mean(perf_rep_t,1);


% plot(t,perf_t.m)