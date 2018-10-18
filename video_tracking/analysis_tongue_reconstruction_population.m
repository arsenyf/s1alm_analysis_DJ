function analysis_tongue_reconstruction_population()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\population_tuning\'];


figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -7 0 0]);

panel_width1=0.15;
panel_height1=0.15;
horizontal_distance1=0.25;
vertical_distance1=0.25;

position_x1(1)=0.1;
position_x1(2)=position_x1(1)+horizontal_distance1;

position_y1(1)=0.8;
position_y1(2)=position_y1(1)-vertical_distance1;
position_y1(3)=position_y1(2)-vertical_distance1;


% key1.brain_area='ALM';
% key1.hemisphere='left';
key.cell_type='Pyr';
key.outcome_grouping='all';
key.flag_use_basic_trials=0;
key.smooth_flag=0;

tuning_param_name{1}='lick_horizoffset';
tuning_param_name{2}='lick_peak_x';
tuning_param_name{3}='lick_rt_video_onset';

lick_direction_name{1}='all';
lick_direction_name{2}='right';
lick_direction_name{3}='left';

time_window_start=([-0.2, 0]);

for i_t=1:1:numel(time_window_start)
    for i_d=1:1:numel(lick_direction_name)
        for oneDnum=1:1:numel(tuning_param_name)
            
            key.tuning_param_name=tuning_param_name{oneDnum};
            key.lick_direction=lick_direction_name{i_d};  %ANL.LickDirectionType
            
            
            key.time_window_start=round(time_window_start(i_t),4);
            
            relSignif = fn_fetch_significant_cells (key);
            
            rel_reconstruction =  ANL.UnitTongue1DTuningReconstruction  & relSignif;
            
            
            tuning_param_label{1}='ML';
            tuning_param_label{2}='AP';
            tuning_param_label{3}='RT';
            
            
            counter=1;
            for recNum=1:1:numel(tuning_param_name)
                if oneDnum==recNum
                    continue
                end
                axes('position',[position_x1(counter), position_y1(oneDnum), panel_width1, panel_height1]);
                fn_plot_reconstruction_population_scatter  (oneDnum, recNum, tuning_param_name, tuning_param_label, key, rel_reconstruction, counter)
                counter=counter+1;
            end
        end
        
        if isempty(dir(dir_save_figure))
            mkdir (dir_save_figure)
        end
        filename=['reconstruction_' key.lick_direction '_' num2str( key.time_window_start*1000) 'ms'];
        figure_name_out=[ dir_save_figure filename];
        eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
        clf
    end
end
