function analysis_tongue_tuning()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
key.tuning_param_name='lick_horizoffset_relative';
lick_direction= 'left';  %ANL.LickDirectionType
dir_save_figure = [dir_root 'Results\video_tracking\tuning_zscore\' key.tuning_param_name '\' lick_direction '\'];

flag_smooth_1D_display=0;
flag_smooth_2D_display=1;

figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -7 0 0]);

panel_width1=0.1;
panel_height1=0.08;
horizontal_distance1=0.2;
vertical_distance1=0.16;

position_x1(1)=0.07;
position_x1(2)=position_x1(1)+horizontal_distance1*0.8;
position_x1(3)=position_x1(2)+horizontal_distance1*0.7;
position_x1(4)=position_x1(3)+horizontal_distance1*0.7;
position_x1(5)=position_x1(4)+horizontal_distance1*0.8;
position_x1(6)=position_x1(5)+horizontal_distance1;


position_y1(1)=0.85;
position_y1(2)=position_y1(1)-vertical_distance1;
position_y1(3)=position_y1(2)-vertical_distance1*0.65;
position_y1(4)=position_y1(3)-vertical_distance1*0.65;
position_y1(5)=position_y1(4)-vertical_distance1*0.65;
position_y1(6)=position_y1(5)-vertical_distance1;
position_y1(7)=position_y1(6)-vertical_distance1;



panel_width2=0.1;
panel_height2=0.08;
horizontal_distance2=0.15;
vertical_distance2=0.19;

position_x2(1)=0.55;
position_x2(2)=position_x2(1)+horizontal_distance2*1.2;
position_x2(3)=position_x2(2)+horizontal_distance2;
position_x2(4)=position_x2(3)+horizontal_distance2;
position_x2(5)=position_x2(4)+horizontal_distance2;
position_x2(6)=position_x2(5)+horizontal_distance2;


position_y2(1)=0.8;
position_y2(2)=position_y2(1)-vertical_distance2;
position_y2(3)=position_y2(2)-vertical_distance2;
position_y2(4)=position_y2(3)-vertical_distance2;
position_y2(5)=position_y2(4)-vertical_distance2;
position_y2(6)=position_y2(5)-vertical_distance2;
position_y2(7)=position_y2(6)-vertical_distance2;


% key1.brain_area='ALM';
% key1.hemisphere='left';
key.cell_type='Pyr';
key.outcome_grouping='all';
key.flag_use_basic_trials=0;
key.smooth_flag=0;
key.lick_direction=lick_direction;
key_time1.time_window_start=round(-0.2,4);
key_time2.time_window_start=round(0,4);
if strcmp(lick_direction,'all')
    rel1= (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance & key & key_time1  & 'number_of_trials>100' & 'total_number_of_spikes_window>100' & 'pvalue_si_1d<=0.001' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
    rel2=(ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance & key & key_time2 & 'number_of_trials>100' & 'total_number_of_spikes_window>100' & 'pvalue_si_1d<=0.001')  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
elseif strcmp(lick_direction,'left')
    rel1= (ANL.UnitTongue1DTuningLRseparate*ANL.UnitTongue1DTuningSignificanceLRseparate & key & key_time1  & 'number_of_trials>50' & 'total_number_of_spikes_window>50' & 'pvalue_si_1d<=0.001' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
    rel2=(ANL.UnitTongue1DTuningLRseparate*ANL.UnitTongue1DTuningSignificanceLRseparate & key & key_time2  & 'number_of_trials>50' & 'total_number_of_spikes_window>50' & 'pvalue_si_1d<=0.001')  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
elseif strcmp(lick_direction,'right')
    rel1= (ANL.UnitTongue1DTuningLRseparate*ANL.UnitTongue1DTuningSignificanceLRseparate & key & key_time1  & 'number_of_trials>50' & 'total_number_of_spikes_window>50' & 'pvalue_si_1d<=0.001' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
    rel2=(ANL.UnitTongue1DTuningLRseparate*ANL.UnitTongue1DTuningSignificanceLRseparate & key & key_time2  & 'number_of_trials>50' & 'total_number_of_spikes_window>50' & 'pvalue_si_1d<=0.001')  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
end

key_1D=key;
key_2D=key;

relSignif=(EPHYS.Unit & 'unit_quality!="multi"') & (rel1 | rel2);

UNITS=struct2table(fetch(relSignif*EPHYS.UnitPosition*EPHYS.UnitCellType ,'*','ORDER BY unit_uid'));

time_window_start=([-0.2, 0]);
% time_window_end=([0, 0.2]);

tuning_param_name_1D{1}='lick_horizoffset_relative';
tuning_param_name_1D{2}='lick_peak_x';
tuning_param_name_1D{3}='lick_rt_video_onset';


tuning_param_name_2D.x{1}='lick_horizoffset_relative';
tuning_param_name_2D.x{2}='lick_horizoffset_relative';
% tuning_param_name_2D.x{3}='lick_yaw';
tuning_param_name_2D.x{3}='lick_rt_video_onset';

tuning_param_name_2D.y{1}='lick_rt_video_onset';
tuning_param_name_2D.y{2}='lick_peak_x';
tuning_param_name_2D.y{3}='lick_peak_x';

if strcmp(key.lick_direction,'all')
    rel_tuning = ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance;
    rel_reconstruction =  ANL.UnitTongue1DTuningReconstruction *ANL.UnitTongue1DTuningSignificance;
elseif strcmp(key.lick_direction,'left')
    rel_tuning = ANL.UnitTongue1DTuningLRseparate*ANL.UnitTongue1DTuningSignificanceLRseparate;
    rel_reconstruction =  ANL.UnitTongue1DTuningReconstructionLRseparate *ANL.UnitTongue1DTuningSignificanceLRseparate;
elseif strcmp(key.lick_direction,'right')
    rel_tuning = ANL.UnitTongue1DTuningLRseparate*ANL.UnitTongue1DTuningSignificanceLRseparate;
    rel_reconstruction =  ANL.UnitTongue1DTuningReconstructionLRseparate *ANL.UnitTongue1DTuningSignificanceLRseparate;
end


for tnum=1:1:numel(time_window_start)
    key_time.time_window_start=round(time_window_start(tnum),4);
    
    for oneDnum=1:1:numel(tuning_param_name_1D)
        key_1D.tuning_param_name=tuning_param_name_1D{oneDnum};
        TUNING{tnum}.oneD{oneDnum}=struct2table(fetch (EPHYS.Unit * ((rel_tuning)  & relSignif & key_time & key_1D ),'*','ORDER BY unit_uid'));
    end
    
    for twoDnum=1:1:numel(tuning_param_name_2D.x)
        key_2D.tuning_param_name_x=tuning_param_name_2D.x{twoDnum};
        key_2D.tuning_param_name_y=tuning_param_name_2D.y{twoDnum};
        TUNING{tnum}.twoD{twoDnum}=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue2DTuning  & relSignif  & key_2D & key_time),'*','ORDER BY unit_uid'));
    end
    
end

for tnum=1:1:numel(time_window_start)
    key_time.time_window_start=round(time_window_start(tnum),4);
    
    for oneDnum=1:1:numel(tuning_param_name_1D)
        key_1D.tuning_param_name=tuning_param_name_1D{oneDnum};
        for recNum=1:1:numel(tuning_param_name_1D)
            key_recon.reconstruction_tuning_param_name=tuning_param_name_1D{recNum};
            if oneDnum==recNum
                TUNING_RECON{tnum}.oneD{oneDnum}.reconstructBy{recNum}=[];
            else
                TUNING_RECON{tnum}.oneD{oneDnum}.reconstructBy{recNum}=struct2table(fetch (EPHYS.Unit * ((rel_reconstruction)  & relSignif & key_time & key_1D & key_recon),'*','ORDER BY unit_uid'));
            end
        end
    end
    
end



% for tnum=1:1:numel(time_window_start)
%     key_time.time_window_start=round(time_window_start(tnum),4);
%
%     for oneDnum=1:1:numel(tuning_param_name_1D)
%         key_1D.tuning_param_name=tuning_param_name_1D{oneDnum};
%         TUNING{tnum}.oneD{oneDnum}=struct2table(fetch (EPHYS.Unit * ((ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance)  & relSignif & key_time & key_1D ),'*','ORDER BY unit_uid'));
%     end
%
%     for twoDnum=1:1:numel(tuning_param_name_2D.x)
%         key_2D.tuning_param_name_x=tuning_param_name_2D.x{twoDnum};
%         key_2D.tuning_param_name_y=tuning_param_name_2D.y{twoDnum};
%         TUNING{tnum}.twoD{twoDnum}=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue2DTuning  & relSignif  & key_2D & key_time),'*','ORDER BY unit_uid'));
%     end
%
% end





for i_u=1:1:size(TUNING{1}.oneD{1},1)
    
    
    axes('position',[position_x1(1), position_y1(1)+0.05, panel_width1, panel_height1]);
    text(0,1,sprintf('unit = %d   %s  %s        %s significance based on %s direction',UNITS.unit_uid(i_u),UNITS.brain_area{i_u,1},UNITS.hemisphere{i_u}, UNITS.cell_type{i_u},lick_direction  ))
    axis off
    box off
    
    %% 1D tuning
    oneDnum=1;
    %%%
    axes('position',[position_x1(oneDnum), position_y1(1), panel_width1, panel_height1]);
    tnum=1;  yyaxis left;
    fn_plot_1Dtuning (TUNING, i_u, tnum, tuning_param_name_1D, time_window_start, oneDnum,flag_smooth_1D_display,key)
    tnum=2; yyaxis right;
    fn_plot_1Dtuning (TUNING, i_u, tnum, tuning_param_name_1D, time_window_start, oneDnum,flag_smooth_1D_display,key)
    %%%
    y1(1)=axes('position',[position_x1(oneDnum), position_y1(2), panel_width1, panel_height1]);  flag_per_spike_or_per_sec=2;
    [yl(1,:)]=fn_plot_si_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key, flag_per_spike_or_per_sec);
    %%%
    yy1(1)=axes('position',[position_x1(oneDnum), position_y1(3), panel_width1, panel_height1]);  flag_per_spike_or_per_sec=1;
    [yyl(1,:)]=fn_plot_si_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key, flag_per_spike_or_per_sec);
    %%%
    axes('position',[position_x1(oneDnum), position_y1(4), panel_width1, panel_height1]);
    fn_plot_stability_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key)
    
    
    oneDnum=2;
    %%%
    axes('position',[position_x1(oneDnum), position_y1(1), panel_width1, panel_height1]);
    tnum=1;  yyaxis left;
    fn_plot_1Dtuning (TUNING, i_u, tnum, tuning_param_name_1D, time_window_start, oneDnum,flag_smooth_1D_display,key)
    tnum=2; yyaxis right;
    fn_plot_1Dtuning (TUNING, i_u, tnum, tuning_param_name_1D, time_window_start, oneDnum,flag_smooth_1D_display,key)
    %%%
    y1(2)=axes('position',[position_x1(oneDnum), position_y1(2), panel_width1, panel_height1]);  flag_per_spike_or_per_sec=2;
    [yl(2,:)]=fn_plot_si_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key, flag_per_spike_or_per_sec);
    %%%
    yy1(2)=axes('position',[position_x1(oneDnum), position_y1(3), panel_width1, panel_height1]);  flag_per_spike_or_per_sec=1;
    [yyl(2,:)]=fn_plot_si_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key, flag_per_spike_or_per_sec);
    %%%
    axes('position',[position_x1(oneDnum), position_y1(4), panel_width1, panel_height1]);
    fn_plot_stability_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key)
    
    
    oneDnum=3;
    %%%
    axes('position',[position_x1(oneDnum), position_y1(1), panel_width1, panel_height1]);
    tnum=1;  yyaxis left;
    fn_plot_1Dtuning (TUNING, i_u, tnum, tuning_param_name_1D, time_window_start, oneDnum,flag_smooth_1D_display,key)
    tnum=2; yyaxis right;
    fn_plot_1Dtuning (TUNING, i_u, tnum, tuning_param_name_1D, time_window_start, oneDnum,flag_smooth_1D_display,key)
    %%%
    y1(3)=axes('position',[position_x1(oneDnum), position_y1(2), panel_width1, panel_height1]);  flag_per_spike_or_per_sec=2;
    [yl(3,:)]=fn_plot_si_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key, flag_per_spike_or_per_sec);
    %%%
    yy1(3)=axes('position',[position_x1(oneDnum), position_y1(3), panel_width1, panel_height1]);  flag_per_spike_or_per_sec=1;
    [yyl(3,:)]=fn_plot_si_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key, flag_per_spike_or_per_sec);
    %%%
    axes('position',[position_x1(oneDnum), position_y1(4), panel_width1, panel_height1]);
    fn_plot_stability_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key)
    
    set(y1(1),'Ylim',[0 max(yl(:,2))]);
    set(y1(2),'Ylim',[0 max(yl(:,2))]);
    set(y1(3),'Ylim',[0 max(yl(:,2))]);
    
    set(yy1(1),'Ylim',[0 max(yyl(:,2))]);
    set(yy1(2),'Ylim',[0 max(yyl(:,2))]);
    set(yy1(3),'Ylim',[0 max(yyl(:,2))]);
    
    if strcmp(lick_direction,'all')
        
        %% ML decoder
        oneDnum=1;
        %%%
        axes('position',[position_x1(oneDnum), position_y1(5), panel_width1, panel_height1]);
        fn_plot_mld_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key)
        oneDnum=2;
        %%%
        %     axes('position',[position_x1(oneDnum), position_y1(5), panel_width1, panel_height1]);
        %     fn_plot_mld_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key)
        oneDnum=3;
        %%%
        %     axes('position',[position_x1(oneDnum), position_y1(5), panel_width1, panel_height1]);
        %     fn_plot_mld_time (TUNING, i_u, tnum, tuning_param_name_1D, oneDnum, key)
    end
    
    %% PSTHs
    axes('position',[position_x1(5), position_y1(6), panel_width1, panel_height1]);
    fn_plot_PSTH_video (TUNING, i_u, 'hit')
    
    axes('position',[position_x1(6), position_y1(6), panel_width1, panel_height1]);
    fn_plot_PSTH_video (TUNING, i_u, 'miss')
    
    
    %% 2D tuning
    twoDnum=1;
    %%%
    axes('position',[position_x1(2), position_y1(6), panel_width1*1.2, panel_height1]);
    tnum=1;
    fn_plot_2Dtuning (TUNING, i_u, tnum, time_window_start, twoDnum, flag_smooth_2D_display)
    axes('position',[position_x1(2), position_y1(7), panel_width1*1.2, panel_height1]);
    tnum=2;
    fn_plot_2Dtuning (TUNING, i_u, tnum, time_window_start, twoDnum, flag_smooth_2D_display)
    
    twoDnum=2;
    %%%
    axes('position',[position_x1(1), position_y1(6), panel_width1*1.2, panel_height1]);
    tnum=1;
    fn_plot_2Dtuning (TUNING, i_u, tnum, time_window_start, twoDnum, flag_smooth_2D_display)
    axes('position',[position_x1(1), position_y1(7), panel_width1*1.2, panel_height1]);
    tnum=2;
    fn_plot_2Dtuning (TUNING, i_u, tnum, time_window_start, twoDnum, flag_smooth_2D_display)
    
    twoDnum=3;
    %%%
    axes('position',[position_x1(3), position_y1(6), panel_width1*1.2, panel_height1]);
    tnum=1;
    fn_plot_2Dtuning (TUNING, i_u, tnum, time_window_start, twoDnum, flag_smooth_2D_display)
    axes('position',[position_x1(3), position_y1(7), panel_width1*1.2, panel_height1]);
    tnum=2;
    fn_plot_2Dtuning (TUNING, i_u, tnum, time_window_start, twoDnum, flag_smooth_2D_display)
    
    
    
    %% Reconstruction
    
    
    for oneDnum=1:1:numel(tuning_param_name_1D)
        key_1D.tuning_param_name=tuning_param_name_1D{oneDnum};
        for recNum=1:1:numel(tuning_param_name_1D)
            key_recon.reconstruction_tuning_param_name=tuning_param_name_1D{recNum};
            if oneDnum==recNum
                continue;
            else
                axes('position',[position_x2(oneDnum), position_y2(recNum), panel_width2, panel_height2]);
                tnum=1;  yyaxis left;
                fn_plot_1DtuningReconstruction (TUNING_RECON, i_u, tnum, tuning_param_name_1D,tuning_param_name_1D, time_window_start, oneDnum,recNum, flag_smooth_1D_display,key)
                tnum=2; yyaxis right;
                fn_plot_1DtuningReconstruction (TUNING_RECON, i_u, tnum, tuning_param_name_1D,tuning_param_name_1D, time_window_start, oneDnum,recNum, flag_smooth_1D_display,key)
            end
        end
    end
    
    
    
    %% Saving
    
    
    
    filename = [UNITS.brain_area{i_u,1} UNITS.hemisphere{i_u} UNITS.cell_type{i_u} num2str(UNITS.unit_uid(i_u)) '_tuning2D'];
    
    
    dir_save_figure_full=[dir_save_figure];
    
    if isempty(dir(dir_save_figure_full))
        mkdir (dir_save_figure_full)
    end
    dir_save_figure_full=[dir_save_figure_full '\' filename ];
    eval(['print ', dir_save_figure_full, ' -dtiff -cmyk -r200']);
    %                 eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
    
    
    clf
end
