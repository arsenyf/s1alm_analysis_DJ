function [decoded_as_error,test_trial_num ] = fn_SVM_decoder_to_identify_LEFTerror_trials(key)
decoded_as_error=[];
test_trial_num=[];
k.session=key.session;
k.subject_id=key.subject_id;

k_trial_type_name.trial_type_name = key.trial_type_name;
trial_type_info = fetch(ANL.TrialTypeStimTime* ANL.TrialTypeInstruction & k_trial_type_name,'*');
if trial_type_info.stimtm_earlydelay~=1000
    distractor_time = trial_type_info.stimtm_earlydelay;
elseif  trial_type_info.stimtm_latedelay~=1000
    distractor_time = trial_type_info.stimtm_latedelay;
elseif strcmp(trial_type_info.trial_type_name,'l')
    [decoded_as_error,test_trial_num ] = fn_SVM_decoder_to_identify_LEFTerror_trials_no_distractor(key);
    return
else
    return
end


psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');

%
% session_uid = fetchn(rel,'session_uid');
% key.session_uid=session_uid(1);

% unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & k & 'unit_quality="ok" or unit_quality="good"' & 'cell_type="Pyr"', 'unit', 'ORDER BY unit_uid');
unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType * EXP.SessionID) & k, 'unit', 'ORDER BY unit_uid');

if isempty(unit_num)
    return
end
psth_t_u_tr = fetch1(ANL.PSTHMatrix * EXP.SessionID & k , 'psth_t_u_tr');
psth_t_u_tr =psth_t_u_tr(:,unit_num,:);



% Training set - on correct/error trials without distractors
%------------------------------------------------------------


tr_left_hit = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & k & 'trial_type_name ="l"' & 'outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');

tr_left_miss = fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & k & 'trial_type_name ="l"' & 'outcome="miss"' & 'early_lick="no early"','trial', 'ORDER BY trial');


left=  [tr_left_hit];
right= [tr_left_miss];

smallest_set_num = min([numel(left),numel(right)]);
if smallest_set_num<3
    return
end

analyzed_trials=  [left;right];
time_window_wo_NANs= psth_t_vector>-2 & psth_t_vector<0;
cells_trials=squeeze(mean(psth_t_u_tr(time_window_wo_NANs,:,analyzed_trials),1));
num_analyzed_trials = numel(analyzed_trials);
stable_cells = sum(isnan(cells_trials),2)<=num_analyzed_trials/4;
psth_t_u_tr = psth_t_u_tr(:,stable_cells,:);


if sum(stable_cells)<5
    return
end

num_repeat = 1;
for i=1:1:num_repeat
%     left=  [datasample(left,smallest_set_num,'Replace',false)];
%     right= [datasample(right,smallest_set_num,'Replace',false)];
    
    
    analyzed_trials=  [left;right];
    
    ix_t = psth_t_vector >= (distractor_time-0.5) & psth_t_vector < distractor_time;
    
    Y(1:numel(left),1)={'left'}';
    Y(numel(left)+1:numel(left)+numel(right))={'right'}';
    
    psth_u_tr_left= squeeze(nanmean(psth_t_u_tr( ix_t,:, left), 1))';
    psth_u_tr_right = squeeze(nanmean(psth_t_u_tr( ix_t,:, right), 1))';
    
    X=[psth_u_tr_left;psth_u_tr_right];
    X(isnan(X))=0;
    
    CVSVMModel = fitcsvm(X,Y,'Holdout',1,'ClassNames',{'right','left'},...
        'Standardize',true);
    CompactSVMModel = CVSVMModel.Trained{1}; % Extract trained, compact classifier
    
    % Test set
    %------------------------------------------------------------
    test_trial_num=  fetchn(EXP.BehaviorTrial * EXP.SessionID * EXP.TrialName & k & k_trial_type_name & 'outcome="miss" or outcome="hit"' & 'early_lick="no early"','trial', 'ORDER BY trial');
    
    if numel(test_trial_num)<2
        return
    end
    
    XTest= squeeze(nanmean(psth_t_u_tr( ix_t,:, test_trial_num), 1))';
    XTest(isnan(XTest))=0;
    
    
    [predicted_label,score] = predict(CompactSVMModel,XTest);
    
    decoded_as_error_rep(i,:)=~strcmp(trial_type_info.trial_instruction,predicted_label);
end
decoded_as_error=sum(decoded_as_error_rep,1)/(num_repeat);
