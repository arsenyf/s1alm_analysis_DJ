function  fn_plotProjection (Param, rel, key_mode, trial_type_substract, ylab)
hold on;

min_num_trials_projected_correct = Param.parameter_value{(strcmp('min_num_trials_projected_correct',Param.parameter_name))};
min_num_trials_projected_error_or_ignore = Param.parameter_value{(strcmp('min_num_trials_projected_error_or_ignore',Param.parameter_name))};
min_num_units_projected = Param.parameter_value{(strcmp('min_num_units_projected',Param.parameter_name))};

if strcmp(key_mode.outcome,'hit')
    min_num_trials_projected = min_num_trials_projected_correct;
else
    min_num_trials_projected = min_num_trials_projected_error_or_ignore;
end


len = 0.4;
sz = [-200 200];

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
smooth_time = Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
mintrials_psth_typeoutcome= Param.parameter_value{(strcmp('mintrials_psth_typeoutcome',Param.parameter_name))};


fill(t_presample_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
fill(t_sample_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
fill(t_earlydelay_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
fill(t_latedelay_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');



plot([t_go t_go], sz, 'k-','LineWidth',2);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);

% idx_few_trials = find(PSTH.num_trials_averaged <mintrials_psth_typeoutcome);
% blank=zeros(size(PSTH.trial_type_name));
% blank(idx_few_trials)=NaN;

% trialtype_uid = unique(PSTH.trialtype_uid,'stable');
% trialtype_name = unique(PSTH.trial_type_name,'stable');
% trialtype_plot_order = unique(PSTH.trialtype_plot_order,'stable');
% for itype = sort(trialtype_plot_order,'descend')'
%     ix=trialtype_plot_order==itype;
% end
%

proj_min = 0;
proj_max = 0;

Proj=struct2table(fetch(rel & key_mode,'*','ORDER BY trialtype_plot_order DESC'));
trial_types = unique(Proj.trial_type_name,'stable');
for itype= 1:1:numel(trial_types)
    P = Proj(strcmp(trial_types{itype},Proj.trial_type_name),:);
    idx_include = (P.num_trials_projected >=min_num_trials_projected & P.num_units_projected >=min_num_units_projected);
    
    if size(P,1)>1 %average across sessions
        Proj_avg=nanmean(P.proj_average(idx_include,:),1);
    else %single session
        Proj_avg=P.proj_average(idx_include,:);
    end
    Proj_smooth = movmean(Proj_avg ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
    
    Proj_smooth_substract=0;
    if ~isempty(trial_type_substract)
        P_substract = Proj(strcmp(trial_type_substract,Proj.trial_type_name),:);
        Proj_avg_substract=nanmean(P_substract.proj_average,1);
        Proj_smooth_substract = movmean(Proj_avg_substract ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
    end
    Proj_to_plot = Proj_smooth-Proj_smooth_substract;
    if ~isempty(Proj_to_plot)
        plot(time,Proj_to_plot,'Color',P.trialtype_rgb(1,:), 'LineWidth', 1.5);
        %     psth_smooth = smooth(PSTH.psth_avg(itype,:),smooth_bins) + blank(itype);
        %     plot(time,psth_smooth, 'Color', PSTH.trialtype_rgb(itype,:), 'LineWidth', 1.5);
        
        proj_min(end+1) = nanmin(Proj_to_plot);
        proj_max (end+1) = nanmax(Proj_to_plot);
    end
end


ylabel (sprintf('%s (A.U.)',ylab),'Fontsize', 12);



xlabel ('Time (s)','Fontsize', 12);
xlim([-4.5 1.5]);
ylim([min(proj_min) max(proj_max)+1]);
