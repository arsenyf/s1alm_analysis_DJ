function  [key, counter] = fn_projectTrialAvg_populate(M, PSTH, key, counter)

weights = [M.mode_unit_weight]';
weights = weights./sqrt(nansum(weights.^2));



% idx_few_trials = find(PSTH.num_trials_averaged <mintrials_psth_typeoutcome);

trial_types = unique(PSTH.trial_type_name);
for itype= 1:1:numel(trial_types)
    P = PSTH(strcmp(trial_types{itype},PSTH.trial_type_name),:);
    P.psth_avg;
    w_mat = repmat(weights,1,size(P.psth_avg,2));

    proj_avg(itype,:) = nansum( (P.psth_avg.*w_mat));
    num_trials_projected(itype) = mode(P.num_trials_averaged); % most common number of trials among the units for this trial-type

    key(counter).subject_id = key(1).subject_id;
    key(counter).session = key(1).session;
    key(counter).cell_type = key(1).cell_type;
    key(counter).unit_quality = key(1).unit_quality;
    key(counter).outcome = key(1).outcome;
    key(counter).task = key(1).task;
    key(counter).trial_type_name = trial_types{itype};
    key(counter).mode_type_name = M(1).mode_type_name;
    key(counter).proj_average = proj_avg(itype,:);
    key(counter).num_trials_projected = num_trials_projected(itype);
    key(counter).hemisphere = P.hemisphere{1}; % assumes the recording in this session where done in one hemisphere only
    key(counter).brain_area = P.brain_area{1}; % assumes the recording in this session where done in one brain area only

    counter = counter +1;

end
