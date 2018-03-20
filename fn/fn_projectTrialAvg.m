function  [proj_avg, trial_types, num_trials_projected] = fn_projectTrialAvg(M, PSTH)

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
end
