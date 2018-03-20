function behv_population()

% clear all;
close all;

dir_save_figure ='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\Results\Behavior\performance\';
mintrials_behav_typeoutcome =fetch1(ANL.Parameters & 'parameter_name="mintrials_behav_typeoutcome"','parameter_value');

% populate(ANL.SessionBehavPerformance);

%% Plotting the behavior performance

figure
set(gcf,'DefaultAxesFontSize',7);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 0 30 24]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[0 0 0 0]);

panel_width=0.25;
panel_height=0.15;
horizontal_distance=0.33;
vertical_distance=0.37;

position_x(1)=0.05;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;

position_y(1)=0.6;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;


%% Expert mice
btt = (EXP.SessionID * ANL.SessionBehavPerformance * EXP.SessionTraining * EXP.SessionTask * EXP.SessionComment)  & 'task_protocol!=3' & 'training_type="distractor"' & 'session_comment="good behavior"';
filename = ['behavior_population_expert'];

% %% Regular mice
% btt = (EXP.SessionID * ANL.SessionBehavPerformance * EXP.SessionTraining * EXP.SessionTask * EXP.SessionComment & 'task_protocol!=3' & 'training_type="regular"' & 'session_comment="good behavior"');
% filename = ['behavior_population_regular'];

trial_type_names = unique(fetchn(btt,'trial_type_name'));
R_trials = [];
L_trials = [];

for i_n=1:1:numel(trial_type_names)
    
    k=[];
    k.trial_type_name = trial_type_names{i_n};
    
    if trial_type_names{i_n}(1) =='r'
        R_trials (end+1) = i_n;
    elseif trial_type_names{i_n}(1) =='l'
        L_trials (end+1) = i_n;
    end
    
    
    idx_enough_trials = fetchn(btt & k, 'total_noignore_noearly', 'ORDER BY session_uid')>=mintrials_behav_typeoutcome;
    %% Fetching
    prcnt_hit(i_n)=  get_field_mean_and_stem (btt, k, 'prcnt_hit',idx_enough_trials);
    prcnt_hit_outof_noignore_noearly (i_n) =  get_field_mean_and_stem (btt, k, 'prcnt_hit_outof_noignore_noearly',idx_enough_trials);
    prcnt_ignore (i_n) = get_field_mean_and_stem (btt, k, 'prcnt_ignore',idx_enough_trials);
    prcnt_early (i_n) = get_field_mean_and_stem (btt, k, 'prcnt_early',idx_enough_trials);
    
    RT_hit_mean (i_n) =   get_field_mean_and_stem (btt, k, 'mean_reaction_time_hit',idx_enough_trials);
    RT_miss_mean (i_n) =   get_field_mean_and_stem (btt, k, 'mean_reaction_time_miss',idx_enough_trials);
    
end

t_r_pure=find(cellfun(@strcmp, trial_type_names, repmat({'r'},numel(trial_type_names),1)));


%Performance
axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
fn_plot_behav_bar (prcnt_hit, R_trials, L_trials, trial_type_names)
ylabel(sprintf('%% Correct \nwith early licks and ignore'))
ylim([0 100]);
inverse_r = 100 - prcnt_hit(t_r_pure).mean;
plot([0 numel(trial_type_names)],[inverse_r inverse_r],'--k');

axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
fn_plot_behav_bar (prcnt_hit_outof_noignore_noearly, R_trials, L_trials, trial_type_names)
ylabel(sprintf('%% Correct \nwithout early licks or ignore'))
ylim([0 100]);
inverse_r = 100 - prcnt_hit_outof_noignore_noearly(t_r_pure).mean;
plot([0 numel(trial_type_names)],[inverse_r inverse_r],'--k');


axes('position',[position_x(3), position_y(1), panel_width, panel_height]);
fn_plot_behav_bar (prcnt_ignore, R_trials, L_trials, trial_type_names)
ylabel('% Ignore')
ylim([0 nanmax([prcnt_ignore.mean])]);


axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
fn_plot_behav_bar (prcnt_early, R_trials, L_trials, trial_type_names)
ylabel('% Early lick')
ylim([0 nanmax([prcnt_early.mean])]);


% Reaction times
axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
fn_plot_behav_bar (RT_hit_mean, R_trials, L_trials, trial_type_names)
ylabel('Reaction Time (s), Correct ')
ylim([0 nanmax([[RT_hit_mean.mean],[RT_miss_mean.mean]])]);

axes('position',[position_x(3), position_y(2), panel_width, panel_height]);
fn_plot_behav_bar (RT_miss_mean, R_trials, L_trials, trial_type_names)
ylabel('Reaction Time (s), Error ')
ylim([0 nanmax([[RT_hit_mean.mean],[RT_miss_mean.mean]])]);




% Saving Figure
%--------------------------------------------------------------------------
if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r200']);
%     eval(['print ', figure_name_out, ' -dpdf -cmyk -r100']);


