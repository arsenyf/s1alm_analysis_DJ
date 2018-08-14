function  POUT = fn_getProjection (Param, rel, key_mode, trial_type_substract,  flag_normalize_modes)

min_num_trials_projected_correct = Param.parameter_value{(strcmp('min_num_trials_projected_correct',Param.parameter_name))};
min_num_trials_projected_error_or_ignore = Param.parameter_value{(strcmp('min_num_trials_projected_error_or_ignore',Param.parameter_name))};
min_num_units_projected = Param.parameter_value{(strcmp('min_num_units_projected',Param.parameter_name))};

if strcmp(key_mode.outcome,'hit')
    min_num_trials_projected = min_num_trials_projected_correct;
else
    min_num_trials_projected = min_num_trials_projected_error_or_ignore;
end

% hold on;
% len = 0.4;
% sz = [-200 200];
%
% xdat = [0 0 len len];
% ydat = [sz(1) sz(2) sz(2) sz(1)];


t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
t_presample_stim = Param.parameter_value{(strcmp('t_presample_stim',Param.parameter_name))};
t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
t_earlydelay_stim = Param.parameter_value{(strcmp('t_earlydelay_stim',Param.parameter_name))};
t_latedelay_stim = Param.parameter_value{(strcmp('t_latedelay_stim',Param.parameter_name))};
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time =Param.parameter_value{(strcmp('smooth_time_proj2D',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
mintrials_psth_typeoutcome= Param.parameter_value{(strcmp('mintrials_psth_typeoutcome',Param.parameter_name))};

t1=-4;
t2=0;
tidx = time>=t1 & time<t2;
% fill(t_presample_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
% fill(t_sample_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
% fill(t_earlydelay_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
% fill(t_latedelay_stim+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
%
%
%
% plot([t_go t_go], sz, 'k-','LineWidth',2);
% plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
% plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);



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
    temp = Proj_smooth-Proj_smooth_substract;
    POUT.p(itype,:) = temp(tidx);
    POUT.rgb(itype,:) = P.trialtype_rgb(1,:);
    POUT.trial_types{itype} = trial_types{itype};
    stim_onset=P.stim_onset{1};
    if isempty(stim_onset)
        POUT.stim_onset_time(itype,1) =  NaN;
        POUT.stim_onset_idx(itype,1) =NaN;
        POUT.stim_onset_time(itype,2) =  NaN;
        POUT.stim_onset_idx(itype,2) =NaN;
    else
        POUT.stim_onset_time(itype,1)  = stim_onset(1);
        POUT.stim_onset_idx(itype,1)  = find(time(tidx)>=stim_onset(1),1);
        POUT.stim_onset_time(itype,2)  = stim_onset(end);
        POUT.stim_onset_idx(itype,2)  = find(time(tidx)>=stim_onset(end),1);
    end
end
POUT.p = POUT.p - nanmean(POUT.p(:,1));
POUT.mode_title = key_mode.mode_title;


key_mode.outcome='hit';
key_mode.trial_type_name='r';
Proj_right_hit=cell2mat(fetchn(rel & key_mode,'proj_average','ORDER BY trialtype_plot_order DESC'));
Proj_right_hit=nanmean(Proj_right_hit(idx_include,:),1);
Proj_right_hit = movmean(Proj_right_hit ,[smooth_bins 0], 2, 'Endpoints','shrink');


if flag_normalize_modes==1
%     POUT.p = POUT.p./nanmax(POUT.p(:));
    POUT.p = POUT.p./nanmax(Proj_right_hit);
end
% ylabel (sprintf('%s (A.U.)',ylab),'Fontsize', 12);
%
%
%
% xlabel ('Time (s)','Fontsize', 12);
% xlim([-4.5 1.5]);
% ylim([min(proj_min) max(proj_max)+1]);
