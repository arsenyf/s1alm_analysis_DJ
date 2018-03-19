function [trialStim_epochs_mat, trialTypeStim_epochs_mat, stim_epochs, trial_type_names] = fn_adaptive_trial_avg_stim_mat(rel)
trial_type_names = unique([fetchn(rel, 'trial_type_name','ORDER BY trial')],'stable');

trialStim_onset{1}= [fetchn(rel, 'stimtm_presample','ORDER BY trial')];
trialStim_onset{2}= [fetchn(rel, 'stimtm_sample','ORDER BY trial')];
trialStim_onset{3}= [fetchn(rel, 'stimtm_earlydelay','ORDER BY trial')];
trialStim_onset{4}= [fetchn(rel, 'stimtm_latedelay','ORDER BY trial')];
trialStim_onset=cell2mat(trialStim_onset);

stim_epochs = [-inf,unique(trialStim_onset)'];
for  i_e =1:1: numel(stim_epochs)-1
    trialStim_epochs_mat(:,i_e)=sum(trialStim_onset>=stim_epochs(i_e) & trialStim_onset<stim_epochs(i_e+1),2);
end


for i=1:1:numel(trial_type_names)
    key.trial_type_name = trial_type_names{i};
    trialTypeStim_onsets(i,1)= fetch1(ANL.TrialTypeStimTime & key, 'stimtm_presample');
    trialTypeStim_onsets(i,2)= fetch1(ANL.TrialTypeStimTime & key, 'stimtm_sample');
    trialTypeStim_onsets(i,3)= fetch1(ANL.TrialTypeStimTime & key, 'stimtm_earlydelay');
    trialTypeStim_onsets(i,4)= fetch1(ANL.TrialTypeStimTime & key, 'stimtm_latedelay');
end

for  i_e =1:1: numel(stim_epochs)-1
    trialTypeStim_epochs_mat(:,i_e)=sum(trialTypeStim_onsets>=stim_epochs(i_e) & trialTypeStim_onsets<stim_epochs(i_e+1),2);
end


