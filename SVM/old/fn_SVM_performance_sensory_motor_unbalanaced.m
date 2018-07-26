function [t,perf_t,set_num] = fn_SVM_performance_sensory_motor_unbalanaced(key)
perf_t=[];
t=[];
set_num=0;



psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');

unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & key & 'unit_quality="ok" or unit_quality="good"' & 'cell_type="Pyr"', 'unit', 'ORDER BY unit_uid');
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

t_step=0.2;
t=-3.2:0.1:1;

for i_subsample = 1:1:20
    %     i_subsample
    smallest_set_num_left = min([numel(tr_left_hit),numel(tr_left_miss)]);
        smallest_set_num_right = min([numel(tr_right_hit),numel(tr_right_miss)]);

    if strcmp(key.sensory_or_motor,'sensory')
        left=  [datasample(tr_left_hit,smallest_set_num_left,'Replace',false);   datasample(tr_left_miss,smallest_set_num_left,'Replace',false)];
        right=  [datasample(tr_right_hit,smallest_set_num_right,'Replace',false);   datasample(tr_right_miss,smallest_set_num_right,'Replace',false)];
        
    end
    
    if strcmp(key.sensory_or_motor,'motor') % labels are given according to the motor output
        left=  [datasample(tr_left_hit,smallest_set_num_left,'Replace',false);   datasample(tr_right_miss,smallest_set_num_right,'Replace',false)];
        right=  [datasample(tr_right_hit,smallest_set_num_right,'Replace',false);   datasample(tr_left_miss,smallest_set_num_left,'Replace',false)];
    end
    
    if (smallest_set_num_left+smallest_set_num_right)*2<5
        return
    end

    for i_t=1:1:numel(t)
        t(i_t);
        ix_t = psth_t_vector >= t(i_t)-t_step & psth_t_vector < t(i_t);
        
        psth_u_tr_left= squeeze(nanmean(psth_t_u_tr( ix_t,:, left), 1))';
        psth_u_tr_right = squeeze(nanmean(psth_t_u_tr( ix_t,:, right), 1))';
        
        X=[psth_u_tr_left;psth_u_tr_right];
        X(isnan(X))=0;
        Y(1:numel(left),1)={'left'}';
        Y(numel(left)+1:numel(left)+numel(right))={'right'}';
        
        rng('default')
        for i_rep = 1:1:50
            CVSVMModel = fitcsvm(X,Y,'Holdout',0.25,'ClassNames',{'right','left'},...
                'Standardize',true);
            CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
            testInds = test(CVSVMModel.Partition);   % Extract the test indices
            XTest = X(testInds,:);
            YTest = Y(testInds,:);
            [predicted_label,score] = predict(CompactSVMModel,XTest);
            %                     table(YTest,predicted_label,score(:,2),'VariableNames',...
            %                         {'TrueLabel','PredictedLabel','Score'})
            perf(i_rep) =     sum(strcmp(YTest,predicted_label))./sum(testInds);
            %             perf(i_rep) = 1- loss(CompactSVMModel,XTest,YTest);
        end
        perf_t(i_subsample,i_t) = mean(perf);
%         perf_t.std (i_subsample,i_t) = std(perf);
%         perf_t.stem (i_subsample,i_t) = std(perf)./sqrt(numel(perf));
        
    end
end
set_num = (smallest_set_num_left+smallest_set_num_right)*2;
