function fn_plot_trial_legend (trialtype_uid)
hold on;

TRIAL = struct2table(fetch(ANL.TrialTypeID * ANL.TrialTypeStimTime * ANL.TrialTypeGraphic,'*','ORDER BY trialtype_uid'));

sz = 10;
counter=1;
for ii = 1:1:numel(trialtype_uid)
    t_idx =trialtype_uid(ii);
    stim_onset = TRIAL.stim_onset{t_idx};
    stim_duration = TRIAL.stim_duration{t_idx};
    for jj = 1:1:numel(stim_onset)
    plot([stim_onset(jj), stim_onset(jj) + stim_duration(jj)], counter*sz+[0 0], 'Color', TRIAL.trialtype_rgb(t_idx,:), 'LineWidth', 3);
    end
    counter = counter + 1;
end


xlim([-4.5 2.5]);
ylim([1, sz*11]);
axis off;