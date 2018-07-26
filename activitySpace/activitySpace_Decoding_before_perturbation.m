function activitySpace_Decoding_before_perturbation()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Population\activitySpace\Modes\Decoding_before_perturbation\'];


key.brain_area = 'ALM'
% key.hemisphere = 'right'
key.training_type = 'distractor'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
condition = 'full'
if strcmp(condition,'mini')
    key.session_flag_mini = 1;
    key.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    key.session_flag_full = 1;
    key.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
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
horizontal_distance=0.2;
vertical_distance=0.2;

position_x(1)=0.05;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;
position_x(7)=position_x(6)+horizontal_distance;
position_x(8)=position_x(7)+horizontal_distance;

position_y(1)=0.65;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;

% Params
Param = struct2table(fetch (ANL.Parameters,'*'));

time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
t_presample_stim = Param.parameter_value{(strcmp('t_presample_stim',Param.parameter_name))};
t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
t_earlydelay_stim = Param.parameter_value{(strcmp('t_earlydelay_stim',Param.parameter_name))};
t_latedelay_stim = Param.parameter_value{(strcmp('t_latedelay_stim',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
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
        
        k_tname.trial_type_name='r';
        proj(4).proj =  movmean(cell2mat(fetchn(rel_Proj & k_s & k_proj & k_tname & 'outcome="hit"','proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
        proj(4).label =  'hit';

    end
    
    
    
    % Early Delay stimulus
    %-------------------
    t1=-2.6;
    t2=-1.6;
    tidx = time>=t1 & time<t2;
    
    for num =1:1:4
        p = fn_compute_proj_avg_and_statistics (proj(num), time, tidx);
        proj_stat(num).label = p.label;
        proj_stat(num).mean (i_s,:) = p.mean;
        proj_stat(num).bin_before_stim_mean (i_s) = p.bin_before_stim_mean;
        proj_stat(num).bin_before_stim_std (i_s) = p.bin_before_stim_std;
    end

end


% Ramping
%-------------------
hist_bins =linspace(-1,1,9);

CI_ramping_l = (proj_stat(1).bin_before_stim_mean -proj_stat(2).bin_before_stim_mean)./(abs(proj_stat(1).bin_before_stim_mean)+abs(proj_stat(2).bin_before_stim_mean));

axes('position',[position_x(1), position_y(1), panel_width, panel_height*2]);
sz = [-200 200];
ydat = [sz(1) sz(2) sz(2) sz(1)];
xdat = [0 0 0.4 0.4];
fill([-1.6 + xdat], ydat, [0.75 0.75 0.75], 'LineStyle', 'None');
    
hold on;
plot(time, squeeze(nanmean(proj_stat(1).mean,1)),'-r');
plot(time, squeeze(nanmean(proj_stat(2).mean,1)),'-m');
plot(time, squeeze(nanmean(proj_stat(3).mean,1)),'-k');
plot(time, squeeze(nanmean(proj_stat(4).mean,1)),'-b');

sz=[-30 200];
plot([t_go t_go], sz, 'k-','LineWidth',2);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
xlabel('Time (s)');
ylabel('Ramping (a.u.)');
xlim([-3.5 1]);
yl = [-5 24];
ylim(yl);
% text(-3,35,'Lick right, Correct','Color',[0 0 1]);
text(-3,32,'Lick left, Correct','Color',[1 0 0]);
text(-3,29,'Lick left, Correct->Error','Color',[1 0 1]);
text(-3,26,'Lick left, Error','Color',[0 0 0]);

% plot([-1.6 -1.2], [yl(2) yl(2)], '-','Color',[1 0.5 0.3],'LineWidth', 3);
plot([t1 t2], [yl(1) yl(1)], '-','Color',[0 0 0],'LineWidth', 3);

axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
hold on;
histogram(CI_ramping_l,hist_bins);
plot([0 0],[0 5],'-k','LineWidth',2);
xlabel(sprintf('Contrast index \n (Left Correct) - ( Left Correct->Error)'));
ylabel('Counts (sessions)');
xlim([-1 1]);
title('Ramping')


%% Late Delay

for i_s = 1:1:numel(session_uid)
    k_s.session_uid=session_uid(i_s);
    
    
    %fetch proj
    mode_names = {'LateDelay'};
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
        
        k_tname.trial_type_name='r';
        proj(4).proj =  movmean(cell2mat(fetchn(rel_Proj & k_s & k_proj & k_tname & 'outcome="hit"','proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
        proj(4).label =  'hit';

    end
    
    
    
    % Early Delay stimulus
    %-------------------
    t1=-2.6;
    t2=-1.6;
    tidx = time>=t1 & time<t2;
    
    for num =1:1:4
        p = fn_compute_proj_avg_and_statistics (proj(num), time, tidx);
        proj_stat(num).label = p.label;
        proj_stat(num).mean (i_s,:) = p.mean;
        proj_stat(num).bin_before_stim_mean (i_s) = p.bin_before_stim_mean;
        proj_stat(num).bin_before_stim_std (i_s) = p.bin_before_stim_std;
    end

end


% Choice
%-------------------
hist_bins =linspace(-1,1,9);

CI_ramping_l = (proj_stat(1).bin_before_stim_mean -proj_stat(2).bin_before_stim_mean)./(abs(proj_stat(1).bin_before_stim_mean)+abs(proj_stat(2).bin_before_stim_mean));


axes('position',[position_x(2), position_y(1), panel_width, panel_height*2]);
sz = [-200 200];
ydat = [sz(1) sz(2) sz(2) sz(1)];
xdat = [0 0 0.4 0.4];
fill([-1.6 + xdat], ydat, [0.75 0.75 0.75], 'LineStyle', 'None');
    
hold on;
plot(time, squeeze(nanmean(proj_stat(1).mean,1)),'-r');
plot(time, squeeze(nanmean(proj_stat(2).mean,1)),'-m');
plot(time, squeeze(nanmean(proj_stat(3).mean,1)),'-k');
plot(time, squeeze(nanmean(proj_stat(4).mean,1)),'-b');

sz=[-30 200];
plot([t_go t_go], sz, 'k-','LineWidth',2);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
xlabel('Time (s)');
ylabel('Choice (a.u.)');
xlim([-3.5 1]);
yl = [-5 24];
ylim(yl);
text(-3,35,'Lick right, Correct','Color',[0 0 1]);
text(-3,32,'Lick left, Correct','Color',[1 0 0]);
text(-3,29,'Lick left, Correct->Error','Color',[1 0 1]);
text(-3,26,'Lick left, Error','Color',[0 0 0]);

% plot([-1.6 -1.2], [yl(2) yl(2)], '-','Color',[1 0.5 0.3],'LineWidth', 3);
plot([t1 t2], [yl(1) yl(1)], '-','Color',[0 0 0],'LineWidth', 3);

axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
hold on;
histogram(CI_ramping_l,hist_bins);
plot([0 0],[0 5],'-k','LineWidth',2);
xlabel(sprintf('Contrast index \n (Left Correct) - ( Left Correct->Error)'));
ylabel('Counts (sessions)');
xlim([-1 1]);
title('Choice')

if contains(key.unit_quality, 'ok or good')
    key.unit_quality = 'ok';
end

filename =[sprintf('decoding_before_perturbation')];

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
