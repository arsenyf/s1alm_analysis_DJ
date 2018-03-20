function  [trialtype_uid] = fn_plot_PSTH (Unit, PSTH, Param, trial_instruction, outcome, trialtype_flag_standard, trialtype_flag_displayset1)

PSTH = PSTH((strcmp(outcome, PSTH.outcome)),:);
if ~isempty(trial_instruction)
    PSTH = PSTH((strcmp(trial_instruction, PSTH.trial_instruction)),:);
end
if ~isempty(trialtype_flag_standard)
    PSTH = PSTH((trialtype_flag_standard== PSTH.trialtype_flag_standard),:);
end
if ~isempty(trialtype_flag_displayset1)
    PSTH = PSTH((trialtype_flag_displayset1== PSTH.trialtype_flag_displayset1),:);
end

trialtype_uid = unique(PSTH.trialtype_uid);
if ~isempty(PSTH)
    hold on;
    len = 0.1;
    sz = [0 200];
    
    xdat = [0 0 len len];
    ydat = [sz(1) sz(2) sz(2) sz(1)];
    
    
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
    
    
    fill(t_presample_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    fill(t_sample_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    fill(t_earlydelay_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    fill(t_latedelay_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    
    
    
    plot([t_go t_go], sz, 'k-','LineWidth',2);
    plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
    
    blank=zeros(size(PSTH.trial_type_name));
    blank(idx_few_trials)=NaN;
%     p(3).psth=smooth(PSTH.psth_avg(p(3).idx,:),smooth_bins) + blank(3);

    for itype = 1:1:size(PSTH.trial_type_name,1)
        psth_smooth = smooth(PSTH.psth_avg(itype,:),smooth_bins) + blank(itype);
        plot(time,psth_smooth, 'Color', PSTH.trialtype_rgb(itype,:), 'LineWidth', 1.5);
    end
    
    ylabel (sprintf('FR (Hz)'),'Fontsize', 12);
    xlabel ('Time (s)','Fontsize', 12);
    xlim([-4.5 2.5]);
    ylim([0 Unit.peak_fr]);
else
    axis off;
end
% axis tight;