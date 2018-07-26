function   fn_plotClusterPhotostim (plot_counter, columns2plot, PSTH, Param, trial_instruction, peak_LR_hit_units,flag_xlabel,ylab,time2plot)

if ~isempty(trial_instruction)
    PSTH = PSTH((strcmp(trial_instruction, PSTH.trial_instruction)),:);
end



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
    mintrials_heirarclusters= Param.parameter_value{(strcmp('mintrials_heirarclusters',Param.parameter_name))};
    
    
    
    fill(t_presample_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    fill(t_sample_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    fill(t_earlydelay_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    fill(t_latedelay_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
    
    
    
    plot([t_go t_go], sz, 'k-','LineWidth',2);
    plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
    
    
    trialtype_uid = unique(PSTH.trialtype_uid,'stable');
    trialtype_name = unique(PSTH.trial_type_name,'stable');
    trialtype_plot_order = unique(PSTH.trialtype_plot_order,'stable');
    for itype = sort(trialtype_plot_order,'descend')'
        ix=trialtype_plot_order==itype;
        PSTHtype=PSTH(PSTH.trialtype_uid==trialtype_uid(ix),:);
        idx_include = find(PSTHtype.num_trials_averaged >=mintrials_heirarclusters);
        psth_avg = PSTHtype.psth_avg(idx_include,:);
        if ~isempty(psth_avg)
            psth_smooth = movmean(psth_avg ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
            psth_smooth = psth_smooth./peak_LR_hit_units(idx_include);
            psth = nanmean(psth_smooth,1);
            plot(time,psth, 'Color', PSTHtype.trialtype_rgb(1,:), 'LineWidth', 1);
        end
    end
    
    if mod(plot_counter,columns2plot)==0
        ylabel(sprintf('%s\nFR norm. (Hz)',ylab));
        if flag_xlabel==1
            xlabel(sprintf('Time (s)\n'));
        end
    end
    xlim([time2plot(1) time2plot(end)]);
    ylim([0 1]);
    set(gca,'xtick',[-4, -2, 0, 2],'ytick',[0 1],'tickdir','out','ticklength',[.04 .04],'fontsize',8)
    
else
    axis off;
end
% axis tight;