function  fn_plotProjection(M, PSTH, Param)
hold on;
% PSTH = PSTH((strcmp(outcome, PSTH.outcome)),:);

weights = [M.mode_unit_weight]';
weights = weights./sqrt(nansum(weights.^2));


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

% idx_few_trials = find(PSTH.num_trials_averaged <mintrials_psth_typeoutcome);
blank=zeros(size(PSTH.trial_type_name));
% blank(idx_few_trials)=NaN;

trial_types = unique(PSTH.trial_type_name);
for itype= 1:1:numel(trial_types)
    P = PSTH(strcmp(trial_types{itype},PSTH.trial_type_name),:);
    P.psth_avg;
    w_mat = repmat(weights,1,size(P.psth_avg,2));
    proj_avg(itype,:) = nansum( (P.psth_avg.*w_mat));
    proj_avg_smooth(itype,:) = smooth(proj_avg(itype,:),smooth_bins) ;
    
    plot(time,proj_avg_smooth(itype,:), 'Color', P.trialtype_rgb(itype,:), 'LineWidth', 1.5);
    
    %     psth_smooth = smooth(PSTH.psth_avg(itype,:),smooth_bins) + blank(itype);
    %     plot(time,psth_smooth, 'Color', PSTH.trialtype_rgb(itype,:), 'LineWidth', 1.5);
end

ylabel (sprintf('FR (Hz)'),'Fontsize', 12);
xlabel ('Time (s)','Fontsize', 12);
xlim([-4.5 2.5]);
ylim([nanmin(proj_avg_smooth(:)) nanmax(proj_avg_smooth(:))]);
