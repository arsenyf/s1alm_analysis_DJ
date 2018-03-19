function [trial_type_names, b] = fn_fetch_behav(dj_query)
trial_type_names = unique(fetchn(dj_query,'trial_type_name', 'ORDER BY trial_type_num'));
inclusion_behav_mintrials =fetch1(ANL.Parameters & 'parameter_name="inclusion_behav_mintrials"','parameter_value');

for i_n=1:1:numel(trial_type_names)
    k=[];
    k.trial_type_name = trial_type_names{i_n};
    idx_enough_trials = fetchn(dj_query & k, 'total_noignore_noearly', 'ORDER BY session_uid')>=inclusion_behav_mintrials;
    b.prcnt_hit(i_n)=  get_field_mean_and_stem (dj_query, k, 'prcnt_hit',idx_enough_trials);
    b.prcnt_hit_outof_noignore (i_n) =  get_field_mean_and_stem (dj_query, k, 'prcnt_hit_outof_noignore',idx_enough_trials);
    b.prcnt_hit_outof_noignore_noearly (i_n) =  get_field_mean_and_stem (dj_query, k, 'prcnt_hit_outof_noignore_noearly',idx_enough_trials);
    b.prcnt_ignore (i_n) = get_field_mean_and_stem (dj_query, k, 'prcnt_ignore',idx_enough_trials);
    b.prcnt_early (i_n) = get_field_mean_and_stem (dj_query, k, 'prcnt_early',idx_enough_trials);
    b.RT_hit_mean (i_n) =   get_field_mean_and_stem (dj_query, k, 'mean_reaction_time_hit',idx_enough_trials);
    b.RT_miss_mean (i_n) =   get_field_mean_and_stem (dj_query, k, 'mean_reaction_time_miss',idx_enough_trials);
end