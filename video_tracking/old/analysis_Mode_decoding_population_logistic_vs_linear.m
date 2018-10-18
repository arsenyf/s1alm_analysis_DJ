function analysis_Mode_decoding_population_logistic_vs_linear()
close all;




dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\mode_decoding_rsq\'];


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



rel=(ANL.TongueModeTrialDecoding *ANL.SessionPosition *EXP.SessionTraining)& ANL.Video1stLickTrialZscoreAllLR;
rel_P=(ANL.ProjTrialNormalized *ANL.SessionPosition *EXP.SessionTraining)& ANL.Video1stLickTrialZscoreAllLR;

% rel_significant_cells=ANL.RegressionUnitSignificance* ANL.SessionPosition*EXP.SessionTraining & ANL.RegressionDecoding2;


key.brain_area = 'ALM';
% key.hemisphere = 'Left';
key.flag_use_basic_trials_decoding=0;
% key.training_type = 'regular';
key.outcome = 'hit';

lick_direction_name{1}='all';
lick_direction_name{2}='right';
lick_direction_name{3}='left';


tuning_param_name_1D{1}='lick_horizoffset_relative';
tuning_param_name_1D{2}='lick_peak_x';
tuning_param_name_1D{3}='lick_rt_video_onset';

tuning_param_label{1}='ML';
tuning_param_label{2}='AP';
tuning_param_label{3}='Reaction time';

mode_type_name=fetchn(ANL.ModeTypeName2,'mode_type_name');
mode_type_label{1}='LateDelay';
mode_type_label{end+1}='Left';
mode_type_label{end+1}='Movement';
mode_type_label{end+1}='MovementOrthog';
mode_type_label{end+1}='Ramping';
mode_type_label{end+1}='RampingOrthog';
mode_type_label{end+1}='Right';

for i_m=1:1:numel(mode_type_name)
    key.mode_type_name=mode_type_name{i_m};
    mode_time1_st=unique(fetchn(ANL.Mode & rel_P & key,'mode_time1_st'));
    mode_time1_end=unique(fetchn(ANL.Mode & rel_P & key,'mode_time1_end'));
    
    
    for i_p=1:1:numel(tuning_param_name_1D)
        for  i_d=1:1:numel(lick_direction_name)
            key.lick_direction=lick_direction_name{i_d};
            key.tuning_param_name =tuning_param_name_1D{i_p};
            
            
            axes('position',[position_x1(i_p), position_y1(i_d), panel_width1, panel_height1]);
            fn_plot_mode_decoding_time_rsq (rel,  key, tuning_param_label{i_p});
            
            axes('position',[position_x1(i_p)+0.13, position_y1(i_d), panel_width1*1.5, panel_height1]);
            fn_plot_mode_scatter_population (rel, key, tuning_param_label{i_p}, rel_P, mode_time1_st,mode_time1_end)
            
        end
    end
    
    if isempty(dir(dir_save_figure))
        mkdir (dir_save_figure)
    end
    filename=['mode__population' mode_type_label{i_m}];
    figure_name_out=[ dir_save_figure filename];
    eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
end

