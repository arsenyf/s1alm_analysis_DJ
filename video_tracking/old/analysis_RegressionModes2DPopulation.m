function analysis_RegressionModes2DPopulation()
close all;


key.regression_time_start=round(0,4);


dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\RegressionModes2D_population2\' 't' num2str(key.regression_time_start) '\'];


figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -7 0 0]);

panel_width1=0.11;
panel_height1=0.17;
horizontal_distance1=0.3;
vertical_distance1=0.32;

position_x1(1)=0.06;
position_x1(2)=position_x1(1)+horizontal_distance1;
position_x1(3)=position_x1(2)+horizontal_distance1;
position_x1(4)=position_x1(3)+horizontal_distance1;
position_x1(5)=position_x1(4)+horizontal_distance1;
position_x1(6)=position_x1(5)+horizontal_distance1;


position_y1(1)=0.73;
position_y1(2)=position_y1(1)-vertical_distance1;
position_y1(3)=position_y1(2)-vertical_distance1;
position_y1(4)=position_y1(3)-vertical_distance1;
position_y1(5)=position_y1(4)-vertical_distance1;
position_y1(6)=position_y1(5)-vertical_distance1;
position_y1(7)=position_y1(6)-vertical_distance1;



rel_P=ANL.RegressionProjTrialNormalizedbetaXR2*ANL.SessionPosition*EXP.SessionTraining;

key.brain_area = 'ALM';
% key.hemisphere = 'Right';
% key.training_type = 'regular';

key.flag_use_basic_trials_decoding=0; %for rel
key.outcome_trials_for_decoding = 'all';  %for rel

% key.outcome='hit';  %for rel_P
% key.trialtype_left_and_right_no_distractors=1; %for rel

lick_direction_name{1}='all';
lick_direction_name{2}='right';
lick_direction_name{3}='left';


tuning_param_name_2D{1}.x='lick_horizoffset_relative';
tuning_param_name_2D{2}.x='lick_horizoffset_relative';
tuning_param_name_2D{3}.x='lick_rt_video_onset';
tuning_param_name_2D{1}.y='lick_rt_video_onset';
tuning_param_name_2D{2}.y='lick_peak_x';
tuning_param_name_2D{3}.y='lick_peak_x';

tuning_param_label_2D{1}.x='ML';
tuning_param_label_2D{2}.x='ML';
tuning_param_label_2D{3}.x='RT';
tuning_param_label_2D{1}.y='RT';
tuning_param_label_2D{2}.y='AP';
tuning_param_label_2D{3}.y='AP';

%% Regression examples
for i_p=1:1:numel(tuning_param_name_2D)
    for  i_d=1:1:numel(lick_direction_name)
        key.lick_direction=lick_direction_name{i_d};
        %         key.tuning_param_name =tuning_param_name_2D{i_p};
        
        
        %         axes('position',[position_x1(i_p), position_y1(i_d), panel_width1, panel_height1]);
        %         fn_plot_regression_decoding_time_logistic_vs_linear (rel,  key, tuning_param_label{i_p});
        graphic_param.position_x =position_x1 (i_p);
        graphic_param.position_y = position_y1(i_d);
        graphic_param.panel_width = panel_width1;
        graphic_param.panel_height= panel_height1;
        
        fn_plot_regression_2D (rel_P, key, tuning_param_name_2D{i_p}, tuning_param_label_2D{i_p}, graphic_param)
        
    end
end

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
filename=['regression_population'];
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
