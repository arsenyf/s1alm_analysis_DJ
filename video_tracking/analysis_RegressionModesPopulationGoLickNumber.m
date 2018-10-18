function analysis_RegressionModesPopulationGoLickNumber()
close all;


key.regression_time_start=round(0,4);


dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\RegressionModes_populationGoLickNumber_signif\' 't' num2str(key.regression_time_start) '\'];


figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -7 0 0]);

panel_width1=0.08;
panel_height1=0.15;
horizontal_distance1=0.3;
vertical_distance1=0.25;

position_x1(1)=0.06;
position_x1(2)=position_x1(1)+horizontal_distance1;
position_x1(3)=position_x1(2)+horizontal_distance1;
position_x1(4)=position_x1(3)+horizontal_distance1;
position_x1(5)=position_x1(4)+horizontal_distance1;
position_x1(6)=position_x1(5)+horizontal_distance1;


position_y1(1)=0.7;
position_y1(2)=position_y1(1)-vertical_distance1;
position_y1(3)=position_y1(2)-vertical_distance1;
position_y1(4)=position_y1(3)-vertical_distance1;
position_y1(5)=position_y1(4)-vertical_distance1;
position_y1(6)=position_y1(5)-vertical_distance1;
position_y1(7)=position_y1(6)-vertical_distance1;



rel=ANL.RegressionDecodingLickNumber*ANL.SessionPosition*EXP.SessionTraining;

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


tuning_param_name_1D{1}='lick_horizoffset';
tuning_param_name_1D{2}='lick_peak_x';
tuning_param_name_1D{3}='lick_rt_video_onset';

tuning_param_label{1}='ML';
tuning_param_label{2}='AP';
tuning_param_label{3}='Reaction time';


%% Regression examples
for flag_exlude_1st_lick=0:1:1
    for i_p=1:1:numel(tuning_param_name_1D)
        for  i_d=1:1:numel(lick_direction_name)
            key.lick_direction=lick_direction_name{i_d};
            key.tuning_param_name =tuning_param_name_1D{i_p};
            
            axes('position',[position_x1(i_p), position_y1(i_d), panel_width1, panel_height1]);
            fn_plot_regression_decoding_time_lick_number (rel,  key, tuning_param_label{i_p}, flag_exlude_1st_lick);
            
        end
    end
    if isempty(dir(dir_save_figure))
        mkdir (dir_save_figure)
    end
    if flag_exlude_1st_lick==0
        filename=['regression_population'];
    else
        filename=['regression_population_exlude_1st_lick'];
        
    end
    figure_name_out=[ dir_save_figure filename];
    
    eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
    clf
end

