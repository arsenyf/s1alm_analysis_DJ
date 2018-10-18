function analysis_tongue_reconstruction_population()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
key.tuning_param_name='lick_horizoffset';
lick_direction= 'right';  %ANL.LickDirectionType
dir_save_figure = [dir_root 'Results\video_tracking\cell_tuning_reconstruction\'];

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
position_x1(4)=position_x1(3)+horizontal_distance1*0.9;
position_x1(5)=position_x1(4)+horizontal_distance1*0.8;
position_x1(6)=position_x1(5)+horizontal_distance1*0.8;


position_y1(1)=0.85;
position_y1(2)=position_y1(1)-vertical_distance1;
position_y1(3)=position_y1(2)-vertical_distance1*0.65;
position_y1(4)=position_y1(3)-vertical_distance1*0.65;
position_y1(5)=position_y1(4)-vertical_distance1*0.65;
position_y1(6)=position_y1(5)-vertical_distance1;
position_y1(7)=position_y1(6)-vertical_distance1;



panel_width2=0.1;
panel_height2=0.07;
horizontal_distance2=0.15;
vertical_distance2=0.165;

position_x2(1)=0.55;
position_x2(2)=position_x2(1)+horizontal_distance2*1.2;
position_x2(3)=position_x2(2)+horizontal_distance2;
position_x2(4)=position_x2(3)+horizontal_distance2;
position_x2(5)=position_x2(4)+horizontal_distance2;
position_x2(6)=position_x2(5)+horizontal_distance2;


position_y2(1)=0.73;
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
    rel1= (ANL.UnitTongue1DTuning *ANL.UnitTongue1DTuningSignificanceGo & key & key_time1  & 'number_of_trials>100' & 'total_number_of_spikes_window>100' & 'pvalue_si_1d<=0.05' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
    rel2=(ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificanceGo & key & key_time2 & 'number_of_trials>100' & 'total_number_of_spikes_window>100' & 'pvalue_si_1d<=0.05')  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
elseif strcmp(lick_direction,'left')
    rel1= (ANL.UnitTongue1DTuning *ANL.UnitTongue1DTuningSignificanceGo & key & key_time1   & 'number_of_trials>50' & 'total_number_of_spikes_window>50' & 'pvalue_si_1d<=0.05' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
    rel2=(ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificanceGo & key & key_time2  & 'number_of_trials>50' & 'total_number_of_spikes_window>50' & 'pvalue_si_1d<=0.05')  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
elseif strcmp(lick_direction,'right')
   rel1= (ANL.UnitTongue1DTuning *ANL.UnitTongue1DTuningSignificanceGo & key & key_time1   & 'number_of_trials>50' & 'total_number_of_spikes_window>50' & 'pvalue_si_1d<=0.05' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
    rel2=(ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificanceGo & key & key_time2  & 'number_of_trials>50' & 'total_number_of_spikes_window>50' & 'pvalue_si_1d<=0.05')  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
end

key_1D=key;
key_2D=key;

relSignif=(EPHYS.Unit & 'unit_quality!="multi"') & (rel1 | rel2);

UNITS=struct2table(fetch(relSignif*EPHYS.UnitPosition*EPHYS.UnitCellType ,'*','ORDER BY unit_uid'));

time_window_start=([-0.2, 0]);
% time_window_end=([0, 0.2]);

tuning_param_name_1D{1}='lick_horizoffset';
tuning_param_name_1D{2}='lick_peak_x';
tuning_param_name_1D{3}='lick_rt_video_onset';

tuning_param_label{1}='ML';
tuning_param_label{2}='AP';
tuning_param_label{3}='RT';




tuning_param_name_2D.x{1}='lick_horizoffset';
tuning_param_name_2D.x{2}='lick_horizoffset';
% tuning_param_name_2D.x{3}='lick_yaw';
tuning_param_name_2D.x{3}='lick_rt_video_onset';

tuning_param_name_2D.y{1}='lick_rt_video_onset';
tuning_param_name_2D.y{2}='lick_peak_x';
tuning_param_name_2D.y{3}='lick_peak_x';

tuning_param_label_2D.x{1}='ML';
tuning_param_label_2D.x{2}='ML';
tuning_param_label_2D.x{3}='RT';

tuning_param_label_2D.y{1}='RT';
tuning_param_label_2D.y{2}='AP';
tuning_param_label_2D.y{3}='AP';



rel_reconstruction =  ANL.UnitTongue1DTuningReconstruction *ANL.UnitTongue1DTuningSignificanceGo;

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
%         TUNING{tnum}.oneD{oneDnum}=struct2table(fetch (EPHYS.Unit * ((ANL.UnitTongue1DTuningZscore*ANL.UnitTongue1DTuningSignificanceZscore)  & relSignif & key_time & key_1D ),'*','ORDER BY unit_uid'));
%     end
%
%     for twoDnum=1:1:numel(tuning_param_name_2D.x)
%         key_2D.tuning_param_name_x=tuning_param_name_2D.x{twoDnum};
%         key_2D.tuning_param_name_y=tuning_param_name_2D.y{twoDnum};
%         TUNING{tnum}.twoD{twoDnum}=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue2DTuning  & relSignif  & key_2D & key_time),'*','ORDER BY unit_uid'));
%     end
%
% end
tnum=2; 
for oneDnum=1:1:numel(tuning_param_name_1D)
    for recNum=1:1:numel(tuning_param_name_1D)
        if oneDnum==recNum
            continue
        end
        rec_error(oneDnum,recNum,:)=TUNING_RECON{tnum}.oneD{oneDnum}.reconstructBy{recNum}.reconstruction_error;
    end
end


figure
subplot(2,2,1)
hold on
rec_x=squeeze(rec_error(1,3,:));
rec_y=squeeze(rec_error(3,1,:));
plot(rec_x,rec_y,'.')

xl=[0,nanmax([rec_x;rec_y])];
yl=[0,nanmax([rec_x;rec_y])];

plot(xl,yl,'-k')
xlim(xl);
ylim(yl);
xlabel(sprintf('ML by RT \n Reconstruction error '));
ylabel(sprintf('RT by ML \n Reconstruction error '));

subplot(2,2,2)
hold on
rec_x=squeeze(rec_error(1,2,:));
rec_y=squeeze(rec_error(2,1,:));
plot(rec_x,rec_y,'.')

xl=[0,nanmax([rec_x;rec_y])];
yl=[0,nanmax([rec_x;rec_y])];

plot(xl,yl,'-k')
xlim(xl);
ylim(yl);
xlabel(sprintf('ML by AP \n Reconstruction error '));
ylabel(sprintf('AP by ML \n Reconstruction error '));

[key.tuning_param_name '\' lick_direction '\']
