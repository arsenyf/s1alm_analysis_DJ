function  [trialtype_uid] = fn_plot_PSTH (Unit, PSTH, Param, trial_instruction, outcome, trialtype_flag_standard, trialtype_flag_full_late)

PSTH = PSTH((strcmp(outcome, PSTH.outcome)),:);
if ~isempty(trial_instruction)
    PSTH = PSTH((strcmp(trial_instruction, PSTH.trial_instruction)),:);
end
if ~isempty(trialtype_flag_standard)
    PSTH = PSTH((trialtype_flag_standard== PSTH.trialtype_flag_standard),:);
end
if ~isempty(trialtype_flag_full_late)
    PSTH = PSTH((trialtype_flag_full_late== PSTH.trialtype_flag_full_late),:);
end

trialtype_uid = unique(PSTH.trialtype_uid);
if ~isempty(PSTH)
    hold on;
    
    
    t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
    t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
    t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
    t_presample_stim = Param.parameter_value{(strcmp('t_presample_stim',Param.parameter_name))};
    t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
    t_earlydelay_stim = Param.parameter_value{(strcmp('t_earlydelay_stim',Param.parameter_name))};
    t_latedelay_stim = Param.parameter_value{(strcmp('t_latedelay_stim',Param.parameter_name))};
    time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
    psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
    smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth',Param.parameter_name))};
    smooth_bins=ceil(smooth_time/psth_time_bin);
    mintrials_psth_typeoutcome= Param.parameter_value{(strcmp('mintrials_psth_typeoutcome',Param.parameter_name))};
    
    idx_few_trials = find(PSTH.num_trials_averaged <mintrials_psth_typeoutcome);
    
    
    %     fill(t_presample_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    %     fill(t_sample_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    %     fill(t_earlydelay_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    %     fill(t_latedelay_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    
    
    sz = [0 200];
    ydat = [sz(1) sz(2) sz(2) sz(1)];
    for itype = 1:1:size(PSTH.trial_type_name,1)
        stim_onset=PSTH.stim_onset{itype,:};
        stim_duration=PSTH.stim_duration{itype,:};
        for istim=1:1:numel(stim_onset)
            xdat = [0 0 stim_duration(istim) stim_duration(istim)];
            fill([stim_onset(istim) + xdat], ydat, [0.75 0.75 0.75], 'LineStyle', 'None');
        end
    end
    
    
    plot([t_go t_go], sz, 'k-','LineWidth',1.5);
    plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
    
    
    blank=zeros(size(PSTH.trial_type_name));
    blank(idx_few_trials)=NaN;
    for itype = 1:1:size(PSTH.trial_type_name,1)
        psth_smooth=  movmean(PSTH.psth_avg(itype,:),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink') + blank(itype);
        plot(time,psth_smooth, 'Color', PSTH.trialtype_rgb(itype,:), 'LineWidth', 1);
    end
    
    ylabel (sprintf('FR (Hz)'),'Fontsize', 12);
    xlabel ('Time (s)','Fontsize', 12);
    xlim([-4.5 2.5]);
    ylim([0 Unit.peak_fr]);
else
    axis off;
end
% axis tight;