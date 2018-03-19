function behv_population_fig()
% clear all;
close all;

dir_save_figure ='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\Results\Behavior\performance\';
filename ='fig_behavior_population';
disp_offset=5.75; %for display only

% populate(ANL.SessionBehavPerformance);

%% Graphics
figure
set(gcf,'DefaultAxesFontSize',7);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 0 30 24]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[0 0 0 0]);

panel_width=0.18;
panel_height=0.13;
horizontal_distance=0.33;
vertical_distance=0.25;

position_x(1)=0.05;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;

position_y(1)=0.8;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;



%% Regular on Mini distractors
% Fetching
%--------------------------------------
b_query= (EXP.SessionID * ANL.SessionBehavPerformance * EXP.SessionTraining * EXP.SessionTask * EXP.SessionComment  & 'task_protocol in (2,5,7,8,9)' & 'training_type="regular"' & 'session_comment="good behavior"');
n_mice = numel(unique(fetchn(b_query,'subject_id')));
clear trial_type_names  b
[trial_type_names, b] = fn_fetch_behav(b_query);
names_right_trials = {'r', 'r_-3.8Mini', 'r_-1.6Mini', 'r_-0.8Mini'};
names_left_trials = {'l', 'l_-3.8Mini','l_-2.5Mini', 'l_-1.6Mini', 'l_-0.8Mini'};
x_r = [1, (-3.8+disp_offset), (-1.6+disp_offset), (-0.8+disp_offset)];
x_l = [1, (-3.8+disp_offset),(-2.5+disp_offset), (-1.6+disp_offset), (-0.8+disp_offset)];
%Performance
% Choosing which trial-types to display
%--------------------------------------
clear behav_param behav_param_mean behav_param_signif trn_r trn_l y_r y_l
behav_param = b.prcnt_hit_outof_noignore_noearly;
[behav_param_mean, behav_param_signif, trn_r, trn_l, y_r, y_l ] = fn_choose_behav_trials(behav_param,trial_type_names, names_right_trials, names_left_trials);
n_sessions = numel(behav_param(trn_r(1)).values);
% Plotting Performance
%-------------------------------------------
axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
title(sprintf('Mini distractor - Regular mice \n %d mice, %d sessions',n_mice, n_sessions));
fn_plot_behav_panel(behav_param,behav_param_mean, behav_param_signif, disp_offset, x_r, x_l, y_r, y_l, trn_r, trn_l )
% Early lick
% Choosing which params & trial-types to display
%--------------------------------------
clear behav_param behav_param_mean behav_param_signif trn_r trn_l y_r y_l
behav_param = b.prcnt_early;
[behav_param_mean, behav_param_signif, trn_r, trn_l, y_r, y_l] = fn_choose_behav_trials(behav_param,trial_type_names, names_right_trials, names_left_trials);
% Plotting 
%-------------------------------------------
axes('position',[position_x(1), position_y(3), panel_width, panel_height]);
title(sprintf('Mini distractor - Regular mice \n %d mice, %d sessions',n_mice, n_sessions));
fn_plot_behav_panel(behav_param,behav_param_mean, behav_param_signif, disp_offset, x_r, x_l, y_r, y_l, trn_r, trn_l )
ylabel('Early lick (%)');
ylim([0 50]);

%% Regular on Full distractors
% Fetching
%--------------------------------------
b_query= (EXP.SessionID * ANL.SessionBehavPerformance * EXP.SessionTraining * EXP.SessionTask * EXP.SessionComment  & 'task_protocol in (7,8,9)' & 'training_type="regular"' & 'session_comment="good behavior"');
n_mice = numel(unique(fetchn(b_query,'subject_id')));
clear trial_type_names  b
[trial_type_names, b] = fn_fetch_behav(b_query);
names_right_trials = {'r', 'r_-0.8Full'};
names_left_trials = {'l', 'l_-0.8Full'};
x_r = [1, (-0.8+disp_offset)];
x_l = [1, (-0.8+disp_offset)];
%Performance
% Choosing which trial-types to display
%--------------------------------------
clear behav_param behav_param_mean behav_param_signif trn_r trn_l y_r y_l
behav_param = b.prcnt_hit_outof_noignore_noearly;
[behav_param_mean, behav_param_signif, trn_r, trn_l, y_r, y_l ] = fn_choose_behav_trials(behav_param,trial_type_names, names_right_trials, names_left_trials);
n_sessions = numel(behav_param(trn_r(1)).values);
% Plotting Performance
%-------------------------------------------
axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
title(sprintf('Full distractor - Regular mice \n %d mice, %d sessions',n_mice, n_sessions));
fn_plot_behav_panel(behav_param,behav_param_mean, behav_param_signif, disp_offset, x_r, x_l, y_r, y_l, trn_r, trn_l )
% Early lick
% Choosing which params & trial-types to display
%--------------------------------------
clear behav_param behav_param_mean behav_param_signif trn_r trn_l y_r y_l
behav_param = b.prcnt_early;
[behav_param_mean, behav_param_signif, trn_r, trn_l, y_r, y_l] = fn_choose_behav_trials(behav_param,trial_type_names, names_right_trials, names_left_trials);
% Plotting 
%-------------------------------------------
axes('position',[position_x(1), position_y(4), panel_width, panel_height]);
title(sprintf('Full distractor - Regular mice \n %d mice, %d sessions',n_mice, n_sessions));
fn_plot_behav_panel(behav_param,behav_param_mean, behav_param_signif, disp_offset, x_r, x_l, y_r, y_l, trn_r, trn_l )
ylabel('Early lick (%)');
ylim([0 50]);


%% Expert on Mini distractors
% Fetching
%--------------------------------------
b_query= (EXP.SessionID * ANL.SessionBehavPerformance * EXP.SessionTraining * EXP.SessionTask * EXP.SessionComment  & 'task_protocol in (2,5,7,8,9)' & 'training_type="regular + distractor"' & 'session_comment="good behavior"');
n_mice = numel(unique(fetchn(b_query,'subject_id')));
clear trial_type_names  b
[trial_type_names, b] = fn_fetch_behav(b_query);
names_right_trials = {'r', 'r_-3.8Mini', 'r_-1.6Mini', 'r_-0.8Mini'};
names_left_trials = {'l', 'l_-3.8Mini','l_-2.5Mini', 'l_-1.6Mini', 'l_-0.8Mini'};
x_r = [1, (-3.8+disp_offset), (-1.6+disp_offset), (-0.8+disp_offset)];
x_l = [1, (-3.8+disp_offset),(-2.5+disp_offset), (-1.6+disp_offset), (-0.8+disp_offset)];

% Choosing which params & trial-types to display
%--------------------------------------
clear behav_param behav_param_mean behav_param_signif trn_r trn_l y_r y_l
behav_param = b.prcnt_hit_outof_noignore_noearly;
[behav_param_mean, behav_param_signif, trn_r, trn_l, y_r, y_l] = fn_choose_behav_trials(behav_param,trial_type_names, names_right_trials, names_left_trials);
n_sessions = numel(behav_param(trn_r(1)).values);
% Plotting Performance
%-------------------------------------------
axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
title(sprintf('Mini distractor - Expert mice \n %d mice, %d sessions',n_mice, n_sessions));
fn_plot_behav_panel(behav_param,behav_param_mean, behav_param_signif, disp_offset, x_r, x_l, y_r, y_l, trn_r, trn_l )
% Early lick
% Choosing which params & trial-types to display
%--------------------------------------
clear behav_param behav_param_mean behav_param_signif trn_r trn_l y_r y_l
behav_param = b.prcnt_early;
[behav_param_mean, behav_param_signif, trn_r, trn_l, y_r, y_l] = fn_choose_behav_trials(behav_param,trial_type_names, names_right_trials, names_left_trials);
% Plotting 
%-------------------------------------------
axes('position',[position_x(2), position_y(3), panel_width, panel_height]);
title(sprintf('Mini distractor - Expert mice \n %d mice, %d sessions',n_mice, n_sessions));
fn_plot_behav_panel(behav_param,behav_param_mean, behav_param_signif, disp_offset, x_r, x_l, y_r, y_l, trn_r, trn_l )
ylabel('Early lick (%)');
ylim([0 50]);



%% Expert on Full distractors
% Fetching
%--------------------------------------
% b_query= (EXP.SessionID * ANL.SessionBehavPerformance * EXP.SessionTraining * EXP.SessionTask * EXP.SessionComment  & 'task_protocol in (4,6,3,2,5,7,8,9)' & 'training_type="regular + distractor"' & 'session_comment="good behavior"');
b_query= (EXP.SessionID * ANL.SessionBehavPerformance * EXP.SessionTraining * EXP.SessionTask * EXP.SessionComment  & 'task_protocol in (4,6)' & 'training_type="regular + distractor"' & 'session_comment="good behavior"');
n_mice = numel(unique(fetchn(b_query,'subject_id')));
clear trial_type_names  b
[trial_type_names, b] = fn_fetch_behav(b_query);
names_right_trials = {'r', 'r_-3.8Full', 'r_-1.6Full', 'r_-0.8Full'};
names_left_trials = {'l', 'l_-3.8Full', 'l_-1.6Full', 'l_-0.8Full'};
x_r = [1, (-3.8+disp_offset), (-1.6+disp_offset), (-0.8+disp_offset)];
x_l = [1, (-3.8+disp_offset), (-1.6+disp_offset), (-0.8+disp_offset)];
% Choosing which trial-types to display
%--------------------------------------
clear behav_param behav_param_mean behav_param_signif trn_r trn_l y_r y_l
behav_param = b.prcnt_hit_outof_noignore_noearly;
[behav_param_mean, behav_param_signif, trn_r, trn_l, y_r, y_l ] = fn_choose_behav_trials(behav_param,trial_type_names, names_right_trials, names_left_trials);
n_sessions = numel(behav_param(trn_r(1)).values);
% Plotting Performance
%-------------------------------------------
axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
title(sprintf('Full distractor - Expert mice \n %d mice, %d sessions',n_mice, n_sessions));
fn_plot_behav_panel(behav_param,behav_param_mean, behav_param_signif, disp_offset, x_r, x_l, y_r, y_l, trn_r, trn_l )
% Early lick
% Choosing which params & trial-types to display
%--------------------------------------
clear behav_param behav_param_mean behav_param_signif trn_r trn_l y_r y_l
behav_param = b.prcnt_early;
[behav_param_mean, behav_param_signif, trn_r, trn_l, y_r, y_l] = fn_choose_behav_trials(behav_param,trial_type_names, names_right_trials, names_left_trials);
% Plotting 
%-------------------------------------------
axes('position',[position_x(2), position_y(4), panel_width, panel_height]);
title(sprintf('Full distractor - Expert mice \n %d mice, %d sessions',n_mice, n_sessions));
fn_plot_behav_panel(behav_param,behav_param_mean, behav_param_signif, disp_offset, x_r, x_l, y_r, y_l, trn_r, trn_l )
ylabel('Early lick (%)');
ylim([0 50]);



% Saving Figure
%--------------------------------------------------------------------------
if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r200']);
eval(['print ', figure_name_out, ' -dpdf -cmyk -r100']);

