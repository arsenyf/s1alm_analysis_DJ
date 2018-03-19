function [behav_param_mean, behav_param_signif, trn_r, trn_l, y_r, y_l ] = fn_choose_behav_trials(behav_param,trial_type_names, names_right_trials, names_left_trials)
behav_param_mean = [behav_param.mean];
behav_param_signif = {behav_param.symbol};
for i=1:1:numel(names_right_trials)
trn_r(i) = find(cellfun(@strcmp, trial_type_names, repmat(names_right_trials(i),numel(trial_type_names),1)));
end
for i=1:1:numel(names_left_trials)
trn_l(i) = find(cellfun(@strcmp, trial_type_names, repmat(names_left_trials(i),numel(trial_type_names),1)));
end
y_r = [behav_param_mean(trn_r)]';
y_l = [behav_param_mean(trn_l)]';
