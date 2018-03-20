function  CD_rotation_time_population()
close all;

dir_save_figure ='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\Results\Population\activitySpace\Modes\Time\';

%% Graphics
figure
set(gcf,'DefaultAxesFontSize',7);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 0 30 24]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[0 0 0 0]);

panel_width=0.17;
panel_height=0.17;
horizontal_distance=0.23;
vertical_distance=0.28;

position_x(1)=0.02;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;

position_y(1)=0.68;
position_y(2)=position_y(1)- vertical_distance;
position_y(3)=position_y(2)- vertical_distance;


%% Fetching and plotting
rel = ANL.CDrotationAverage;
time = fetch1 (rel , 'mode_mat_timebin_vector', 'LIMIT 1');
% key.mode_avg_mat_corr_id=1; % using only l/r trials that did not have photostim
key.mode_avg_mat_corr_id=2; % using all l/r trials, incuding those that had photostim

% ALM left
%--------------------------------------------------------------------------
key.brain_area = 'ALM';
key.hemisphere = 'left';

% Regular mice
key.training_type ='regular';
r = fetch1 (rel & key ,'avg_mode_mat_t_weights_corr');
axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
fn_plot_CD_rotation(time,r);
title(sprintf('%s  mice \n \n %s %s \n', 'Regular', key.brain_area, key.hemisphere), 'FontSize',14);

% Expert mice
key.training_type ='distractor';
r = fetch1 (rel & key ,'avg_mode_mat_t_weights_corr');
axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
fn_plot_CD_rotation(time,r);
title(sprintf('%s  mice \n \n %s %s \n', 'Expert', key.brain_area, key.hemisphere), 'FontSize',14);

% Regular & Expert mice
key.training_type ='all';
r = fetch1 (rel & key ,'avg_mode_mat_t_weights_corr');
axes('position',[position_x(3), position_y(1), panel_width, panel_height]);
fn_plot_CD_rotation(time,r);
title(sprintf('%s  mice \n \n %s %s \n', 'Regular & Expert', key.brain_area, key.hemisphere), 'FontSize',14);


% ALM right
%--------------------------------------------------------------------------
key.brain_area = 'ALM';
key.hemisphere = 'right';

% Regular mice
key.training_type ='regular';
r = fetch1 (rel & key ,'avg_mode_mat_t_weights_corr');
axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
fn_plot_CD_rotation(time,r);
title(sprintf('\n %s %s \n',key.brain_area, key.hemisphere), 'FontSize',14);

% Expert mice
key.training_type ='distractor';
r = fetch1 (rel & key ,'avg_mode_mat_t_weights_corr');
axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
fn_plot_CD_rotation(time,r);
title(sprintf('\n %s %s \n',  key.brain_area, key.hemisphere), 'FontSize',14);

% Regular & Expert mice
key.training_type ='all';
r = fetch1 (rel & key ,'avg_mode_mat_t_weights_corr');
axes('position',[position_x(3), position_y(2), panel_width, panel_height]);
fn_plot_CD_rotation(time,r);
title(sprintf('\n %s %s \n',  key.brain_area, key.hemisphere), 'FontSize',14);

% S1 left
%--------------------------------------------------------------------------
key.brain_area = 'vS1';
key.hemisphere = 'left';

% Regular mice
key.training_type ='regular';
r = fetch1 (rel & key ,'avg_mode_mat_t_weights_corr');
axes('position',[position_x(1), position_y(3), panel_width, panel_height]);
fn_plot_CD_rotation(time,r);
title(sprintf('\n %s %s \n',key.brain_area, key.hemisphere), 'FontSize',14);

% Expert mice
key.training_type ='distractor';
r = fetch1 (rel & key ,'avg_mode_mat_t_weights_corr');
axes('position',[position_x(2), position_y(3), panel_width, panel_height]);
fn_plot_CD_rotation(time,r);
title(sprintf('\n %s %s \n',  key.brain_area, key.hemisphere), 'FontSize',14);

% Regular & Expert mice
key.training_type ='all';
r = fetch1 (rel & key ,'avg_mode_mat_t_weights_corr');
axes('position',[position_x(3), position_y(3), panel_width, panel_height]);
fn_plot_CD_rotation(time,r);
title(sprintf('\n %s %s \n',  key.brain_area, key.hemisphere), 'FontSize',14);


filename = ['CD_rotation_population'];
fn_saveFigure (dir_save_figure, filename, 3);


