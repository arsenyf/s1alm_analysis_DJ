function fn_plot_trial_legend (trialtype_uid, PSTH)
hold on;

sz = 10;
counter=1;
for ii = 1:1:numel(trialtype_uid)
    t_id = find(trialtype_uid(ii) ==  PSTH.trialtype_uid,1);
    stim_onset = PSTH.stim_onset{t_id};
    stim_duration = PSTH.stim_duration{t_id};
    for jj = 1:1:numel(stim_onset)
    plot([stim_onset(jj), stim_onset(jj) + stim_duration(jj)], counter*sz+[0 0], 'Color', PSTH.trialtype_rgb(t_id,:), 'LineWidth', 3);
    end
    counter = counter + 1;
end


xlim([-4.5 2.5]);
ylim([1, sz*11]);
axis off;