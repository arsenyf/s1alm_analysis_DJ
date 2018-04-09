function activitySpace_Modes()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Results\Population\activitySpace\Modes\'];


key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'distractor'
key.unit_quality = 'ok or good'
key.cell_type = 'all'
condition = 'full'

if strcmp(condition,'mini')
    key.session_flag_mini = 1;
    key_mode.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    key.session_flag_full = 1;
    key_mode.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
    key.session_flag_full_late = 1;
    key_mode.trialtype_flag_full_late = 1;
end

k = key;
    rel =(EXP.Session * EXP.SessionID * ANL.ProjTrialAverage * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction * EXP.SessionComment * ANL.IncludeSession) & k & 'unit_quality!="multi"' & 'good_session_flag=1';

%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);


Param = struct2table(fetch (ANL.Parameters,'*'));

  time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
    psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
    smooth_time = Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
    smooth_bins=ceil(smooth_time/psth_time_bin);


mode_names = {'Stimulus','EarlyDelay','LateDelay','Ramping'};
    key_mode.mode_type_name = mode_names{3};
    key_mode.outcome = 'miss';
%     key_mode.trial_type_name = 'hit';
Proj=struct2table(fetch(rel & key_mode,'*'));

 trial_types = unique(Proj.trial_type_name);
 recovery_offset = 0.6;
 for itype= 1:1:numel(trial_types)
    P = Proj(strcmp(trial_types{itype},Proj.trial_type_name),:);
    idx_include = (P.num_trials_projected >=5 & P.num_units_projected >=5);
    
    Proj_avg=nanmean(P.proj_average(idx_include,:),1);
    Proj_smooth = movmean(Proj_avg ,[smooth_bins 0], 2, 'Endpoints','shrink');
    key_name.trial_type_name = trial_types{itype};
    stim_onset = fetch1 (ANL.TrialTypeStimTime & key_name,'stim_onset');
    
    if ~isempty(stim_onset)
        slope_t_start = stim_onset(end) + recovery_offset;
        slope_t_end = slope_t_start + 0.2;
slope_t_idx = find(time>= slope_t_start & time< slope_t_end);
time_for_slope = time(slope_t_idx);
Proj_for_slope = Proj_smooth(slope_t_idx);
slope = nanmean(diff(Proj_for_slope)./diff(time_for_slope))
    end
    
 end
