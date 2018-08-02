function activitySpace_ModesVariance()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Population\activitySpace\Modes\Variance\'];


key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'regular'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
k=key;
k.outcome='hit';

k_proj.mode_weights_sign='all';
% k.session_uid=32;
if contains(k.unit_quality, 'ok or good')
    k = rmfield(k,'unit_quality')
    rel_PSTH = (( ANL.PSTHAverageLR * EXP.Session * EXP.SessionID * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining  ) ) & ANL.IncludeUnit & k & 'unit_quality!="multi"' ;
    rel_Proj = (( ANL.ProjTrialAverage * EXP.Session * EXP.SessionID  * EXP.SessionTraining  )) & k & k_proj & 'unit_quality="ok or good"' ;
else
    rel_PSTH = (( ANL.PSTHAverageLR * EXP.Session * EXP.SessionID * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining  )) & ANL.IncludeUnit & k ;
    rel_Proj = (( ANL.ProjTrialAverage * EXP.Session * EXP.SessionID   * EXP.SessionTraining ) ) & k & k_proj;
end


%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
panel_width=0.1;
panel_height=0.09;
horizontal_distance=0.14;
vertical_distance=0.15;

position_x(1)=0.05;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;
position_x(7)=position_x(6)+horizontal_distance;
position_x(8)=position_x(7)+horizontal_distance;

position_y(1)=0.7;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;

% Params
Param = struct2table(fetch (ANL.Parameters,'*'));
t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};

time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth_for_clustering',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
baseline_idx_time = (time>= -4 & time<=-3);

time_window = 0.1;
time_start = -2.5;
time_end =2;

%% loop over sessions
session_uid = unique(fetchn(rel_Proj,'session_uid'));

for i_s = 1:1:numel(session_uid)
    k_s.session_uid=session_uid(i_s);

    %fetch selectivity

    psth_left = movmean(cell2mat(fetchn(rel_PSTH & k_s & 'trial_type_name="l"','psth_avg')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
    psth_right = movmean(cell2mat(fetchn(rel_PSTH & k_s & 'trial_type_name="r"','psth_avg')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
    
    unit_selectivity = abs(psth_right - psth_left);

    psth_left = psth_left - nanmean(psth_left (:,baseline_idx_time),2);
    psth_right = psth_right - nanmean(psth_right (:,baseline_idx_time),2);

    
    %fetch proj
    mode_names = {'LateDelay', 'Stimulus Orthog.','EarlyDelay Orthog.','Ramping Orthog.'};
%     mode_names = {'LateDelay', 'Stimulus','EarlyDelay ','Ramping Orthog.'};

    for i_m = 1:1:numel(mode_names)
        k_proj.mode_type_name = mode_names{i_m};
        proj_l(i_m,:) = movmean((fetch1(rel_Proj & k_s & k_proj & 'trial_type_name="l"','proj_average')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
        proj_r(i_m,:) =  movmean((fetch1(rel_Proj & k_s & k_proj & 'trial_type_name="r"','proj_average')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
        proj_select(i_m,:) = proj_r(i_m,:) - proj_l(i_m,:);
        
        proj_l(i_m,:) = proj_l(i_m,:) - nanmean(proj_l (i_m,baseline_idx_time));
        proj_r(i_m,:) = proj_r(i_m,:) - nanmean(proj_r (i_m,baseline_idx_time));

    end
    
    cnt=1;
    for i_t=time_start:time_window:time_end
        idx_time = (time>= i_t & time<=(i_t+time_window));
        
        % selectivity explained
        total_selectivity(i_s,cnt) = sum(nanmean(unit_selectivity(:,idx_time),2).^2);
        total_proj_select(i_s,:,cnt) = nanmean(proj_select(:,idx_time),2).^2;
        s_explained(i_s,:,cnt) = total_proj_select(i_s,:,cnt)./total_selectivity(i_s,cnt)'; %selectivity explained
        
        % Trial-averaged variance explained
        total_var(i_s,cnt) = sum(nanmean(psth_left(:,idx_time),2).^2)+sum(nanmean(psth_right(:,idx_time),2).^2);
        total_proj_var(i_s,:,cnt) = nanmean(proj_l(:,idx_time),2).^2 + nanmean(proj_r(:,idx_time),2).^2;
        trialavg_v_explained(i_s,:,cnt) = total_proj_var(i_s,:,cnt)./total_var(i_s,cnt)'; %selectivity explained
        
        
        cnt=cnt+1;
    end
end

time2plot = time_start:time_window:time_end;


axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
selectivity_explained.m = squeeze(mean(s_explained,1));
selectivity_explained.stem = squeeze(std(s_explained,1,1))./sqrt(numel(session_uid));
hold on
shadedErrorBar(time2plot,selectivity_explained.m(1,:),selectivity_explained.stem(1,:),'lineprops',{'b-','markerfacecolor','b','linewidth',1});
shadedErrorBar(time2plot,selectivity_explained.m(2,:),selectivity_explained.stem(2,:),'lineprops',{'r-','markerfacecolor','r','linewidth',1});
shadedErrorBar(time2plot,selectivity_explained.m(3,:),selectivity_explained.stem(3,:),'lineprops',{'g-','markerfacecolor','g','linewidth',1});
shadedErrorBar(time2plot,selectivity_explained.m(4,:),selectivity_explained.stem(4,:),'lineprops',{'m-','markerfacecolor','m','linewidth',1});
plot(time2plot,sum(selectivity_explained.m(:,:)),'-k','linewidth',1);

xlabel('Time(s)');
ylabel('Selectivity explained');
xlim([time_start time_end]);
ylim([0 1.2]);

axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
trialavg_var_explained.m = squeeze(nanmean(trialavg_v_explained,1));
trialavg_var_explained.stem = squeeze(nanstd(trialavg_v_explained,1,1))./sqrt(numel(session_uid));
hold on
shadedErrorBar(time2plot,trialavg_var_explained.m(1,:),trialavg_var_explained.stem(1,:),'lineprops',{'b-','markerfacecolor','b','linewidth',1});
shadedErrorBar(time2plot,trialavg_var_explained.m(2,:),trialavg_var_explained.stem(2,:),'lineprops',{'r-','markerfacecolor','r','linewidth',1});
shadedErrorBar(time2plot,trialavg_var_explained.m(3,:),trialavg_var_explained.stem(3,:),'lineprops',{'g-','markerfacecolor','g','linewidth',1});
shadedErrorBar(time2plot,trialavg_var_explained.m(4,:),trialavg_var_explained.stem(4,:),'lineprops',{'m-','markerfacecolor','m','linewidth',1});
plot(time2plot,sum(trialavg_var_explained.m(:,:)),'-k','linewidth',1);

xlabel('Time(s)');
ylabel('Variance explained');
xlim([time_start time_end]);
ylim([0 1.2]);


if contains(key.unit_quality, 'ok or good')
    key.unit_quality = 'ok';
end

filename =[sprintf('%s%s_Training_%s_UnitQuality_%s_Type_%s_Variance' ,key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type)];

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);

% 

end




