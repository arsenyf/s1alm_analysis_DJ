function activitySpace_ErrorSwitchDecoder()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Population\activitySpace\Modes\Ramping\'];


key.brain_area = 'ALM'
% key.hemisphere = 'right'
key.training_type = 'distractor'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
condition = 'Full'
if strcmp(condition,'Mini')
    key.session_flag_mini = 1;
    key.trialtype_flag_mini = 1;
elseif strcmp(condition,'Full')
    key.session_flag_full = 1;
    key.trialtype_flag_full = 1;
elseif strcmp(condition,'Full_late')
    key.session_flag_full_late = 1;
    key.trialtype_flag_full_late = 1;
end
k=key;
% k.outcome='hit';

k_proj.mode_weights_sign='all';

if contains(k.unit_quality, 'ok or good')
    k = rmfield(k,'unit_quality')
    rel_Proj = (( ANL.ProjTrial * EXP.Session * EXP.SessionID  * EXP.SessionTraining *ANL.SessionGrouping )) & k & k_proj & 'unit_quality="ok or good"' ;
else
    rel_Proj = (( ANL.ProjTrial * EXP.Session * EXP.SessionID  * EXP.SessionTraining *ANL.SessionGrouping )) & k & k_proj ;

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

time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth_for_clustering',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);

%% loop over sessions
session_uid = unique(fetchn(rel_Proj,'session_uid'));

for i_s = 1:1:numel(session_uid)
    k_s.session_uid=session_uid(i_s);
    
    
    %fetch proj
    mode_names = {'Ramping Orthog.'};
    %         mode_names = {'Ramping Orthog.', 'LateDelay', 'Stimulus Orthog.','EarlyDelay Orthog.'};
    %     mode_names = {'LateDelay', 'Stimulus','EarlyDelay ','Ramping Orthog.'};
    
    for i_m = 1:1:numel(mode_names)
        k_proj.mode_type_name = mode_names{i_m};
        
        k_tname.trial_type_name='l_-1.6Full';

        proj(1).proj =  movmean(cell2mat(fetchn(rel_Proj & k_s & k_proj & k_tname & 'outcome="hit"','proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
        proj(1).label =  'hit';
          
        proj(2).proj =  movmean(cell2mat(fetchn((rel_Proj * ANL.SVMdecoderFindErrorTrials) & k_s & k_proj & k_tname & 'outcome="miss"' & 'trial_decoded_as_error=0','proj_trial','ORDER BY trial' )),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
        proj(2).label =  'decoded as correct prior to perturbation';
        
        proj(3).proj =  movmean(cell2mat(fetchn((rel_Proj * ANL.SVMdecoderFindErrorTrials) & k_s & k_proj & k_tname & 'outcome="miss"' & 'trial_decoded_as_error=1','proj_trial','ORDER BY trial' )),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
        proj(3).label =  'decoded as error prior to perturbation';

        
                
    end
    

    % Early Delay stimulus
    %-------------------
    t1=-2.6;
    t2=-1.6;
    tidx = time>=t1 & time<t2;
    
    for num =1:1:3
        p = fn_compute_proj_avg_and_statistics (proj(num), time, tidx);
        proj_stat(num).label = p.label;
        proj_stat(num).mean (i_s,:) = p.mean;
        proj_stat(num).bin_before_stim_mean (i_s) = p.bin_before_stim_mean;
        proj_stat(num).bin_before_stim_std (i_s) = p.bin_before_stim_std;
    end

 
end


% Early Delay stimulus
%-------------------
hist_bins =linspace(-1,1,9);

CI_ramping_l = (proj_stat(1).bin_before_stim_mean -proj_stat(2).bin_before_stim_mean)./(abs(proj_stat(1).bin_before_stim_mean)+abs(proj_stat(2).bin_before_stim_mean));
% CI_ramping_l = (preceding_ramping_l_hit.m(num,:)-preceding_ramping_l_miss.m(num,:))./sqrt(0.5*(preceding_ramping_l_hit.std(num,:).^2+preceding_ramping_l_miss.std(num,:).^2 ));

% CI_ramping_r = (preceding_ramping_r_hit(num,:)-peceding_ramping_r_miss(num,:))./(abs(preceding_ramping_r_hit(num,:))+abs(peceding_ramping_r_miss(num,:)));

axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
hold on;
histogram(CI_ramping_l,hist_bins);
plot([0 0],[0 5],'-k','LineWidth',2);
xlabel('Contrast index');
ylabel('Counts (sessions)');
xlim([-1 1]);
title('Early-delay stimulus')
% axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
% hold on;
% histogram(CI_ramping_r,hist_bins)
% plot([0 0],[0 5],'-k','LineWidth',2);
% xlabel('Contrast index');
% ylabel('Counts (sessions)');
% xlim([-1 1]);

axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
hold on;
% shadedErrorBar(time,squeeze(nanmean(proj_stat(1).mean,1)) ,squeeze(nanstd(proj_stat(1).mean,1))./sqrt(size(proj_stat(1).mean,1)),'lineprops',{'r-','markerfacecolor','r','linewidth',1});
% shadedErrorBar(time,squeeze(nanmean(proj_stat(2).mean,1)) ,squeeze(nanstd(proj_stat(2).mean,1))./sqrt(size(proj_stat(2).mean,1)),'lineprops',{'m-','markerfacecolor','m','linewidth',1});
% shadedErrorBar(time,squeeze(nanmean(proj_stat(3).mean,1)) ,squeeze(nanstd(proj_stat(3).mean,1))./sqrt(size(proj_stat(3).mean,1)),'lineprops',{'k-','markerfacecolor','k','linewidth',1});

plot(time, squeeze(nanmean(proj_stat(1).mean,1)),'-r');
plot(time, squeeze(nanmean(proj_stat(2).mean,1)),'-m');
plot(time, squeeze(nanmean(proj_stat(3).mean,1)),'-k');
% plot(time, squeeze(nanmean(proj_stat(4).mean,1)),'-b');

xlabel('Time(s)');
ylabel('Ramping proj. (a.u.)');
xlim([-3.5 1]);
% ylim([min([squeeze(nanmean(proj_stat(1).mean,1));squeeze(nanmean(ramping_l_miss (num,:,:),2))]), max([squeeze(nanmean(ramping_l_hit (num,:,:),2));squeeze(nanmean(ramping_l_miss (num,:,:),2))])]);
text(-3,20,'Correct','Color',[1 0 0]);
text(-3,15,'Error','Color',[1 0 1]);

% % Late Delay stimulus
% %-------------------
% num=2;
% CI_ramping_l = (preceding_ramping_l_hit.m(num,:)-preceding_ramping_l_miss.m(num,:))./(abs(preceding_ramping_l_hit.m(num,:))+abs(preceding_ramping_l_miss.m(num,:)));
% % CI_ramping_l = (preceding_ramping_l_hit.m(num,:)-preceding_ramping_l_miss.m(num,:))./sqrt(0.5*(preceding_ramping_l_hit.std(num,:).^2+preceding_ramping_l_miss.std(num,:).^2 ));
% 
% % CI_ramping_r = (preceding_ramping_r_hit(num,:)-peceding_ramping_r_miss(num,:))./(abs(preceding_ramping_r_hit(num,:))+abs(peceding_ramping_r_miss(num,:)));
% 
% axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
% hold on;
% histogram(CI_ramping_l,hist_bins)
% plot([0 0],[0 5],'-k','LineWidth',2);
% xlabel('Contrast index');
% ylabel('Counts (sessions)');
% xlim([-1 1]);
% title('Late-delay stimulus')
% 
% 
% % axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
% % hold on;
% % histogram(CI_ramping_r,hist_bins)
% % plot([0 0],[0 5],'-k','LineWidth',2);
% % xlabel('Contrast index');
% % ylabel('Counts (sessions)');
% % xlim([-1 1]);
% 
% axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
% hold on;
% plot(time, squeeze(nanmean(ramping_l_hit (num,:,:),2)),'-r');
% plot(time, squeeze(nanmean(ramping_l_miss (num,:,:),2)),'-m');
% xlabel('Time(s)');
% ylabel('Ramping proj. (a.u.)');
% xlim([-3.5 1]);
% ylim([min([squeeze(nanmean(ramping_l_hit (num,:,:),2));squeeze(nanmean(ramping_l_miss (num,:,:),2))]), max([squeeze(nanmean(ramping_l_hit (num,:,:),2));squeeze(nanmean(ramping_l_miss (num,:,:),2))])]);
% text(-3,15,'Correct','Color',[1 0 0]);
% text(-3,10,'Error','Color',[1 0 1]);

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
% %
%
% end
%
%
%
%
