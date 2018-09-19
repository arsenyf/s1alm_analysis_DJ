function analysis_tongue_tuning_population()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\'];



figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);

panel_width1=0.1;
panel_height1=0.08;
horizontal_distance1=0.17;
vertical_distance1=0.14;

position_x1(1)=0.1;
position_x1(2)=position_x1(1)+horizontal_distance1;
position_x1(3)=position_x1(2)+horizontal_distance1;
position_x1(4)=position_x1(3)+horizontal_distance1*1.1;
position_x1(5)=position_x1(4)+horizontal_distance1*1.1;
position_x1(6)=position_x1(5)+horizontal_distance1;

position_y1(1)=0.85;
position_y1(2)=position_y1(1)-vertical_distance1;
position_y1(3)=position_y1(2)-vertical_distance1;
position_y1(4)=position_y1(3)-vertical_distance1;
position_y1(5)=position_y1(4)-vertical_distance1;
position_y1(6)=position_y1(5)-vertical_distance1;
position_y1(7)=position_y1(6)-vertical_distance1;



Param = struct2table(fetch (ANL.Parameters,'*'));
t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
len = 0.4;
sz = [-100 100];

% xdat = [0 0 len len];
% ydat = [sz(1) sz(2) sz(2) sz(1)];


key1.brain_area='ALM';
% key1.hemisphere='left';
key.cell_type='Pyr';
key.outcome_grouping='all';
key.flag_use_basic_trials=0;
key.smooth_flag=0;


tuning_param_name_1D{1}='lick_horizoffset_relative';
tuning_param_name_1D{2}='lick_peak_x';
tuning_param_name_1D{3}='lick_rt_video_onset';
color1=[0.5 0.5 0.5]; %non signif
color2=[0 1 0]; % signif




%% Conjunctive tuning
time_window_start=round([-0.6,0],4);

for tnum=1:1:numel(time_window_start)
    key_time.time_window_start=time_window_start(tnum);
    for oneDnum=1:1:numel(tuning_param_name_1D)
        key_1D.tuning_param_name=tuning_param_name_1D{oneDnum};
        rel1= (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance & key_1D & key_time & key & 'number_of_trials>100' & 'total_number_of_spikes_window>100' & 'pvalue_si_1d<=0.01' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
        relSignif_temp=(EPHYS.Unit & 'unit_quality!="multi"') & rel1;
%         relAll=EPHYS.Unit * (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance   & key_1D & key_time & key) & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
        
        for oneDnum2=1:1:numel(tuning_param_name_1D)
           key_1D.tuning_param_name=tuning_param_name_1D{oneDnum2};
           relSignif=EPHYS.Unit * (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance  & relSignif_temp & key_1D & key_time & key) & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;

            SI(tnum,oneDnum).values(:,oneDnum2)=((fetchn(relSignif,'tongue_tuning_1d_si','ORDER BY unit_uid')));
            %         SI_all(tnum,oneDnum).values=((fetchn(relAll ,'tongue_tuning_1d_si','ORDER BY unit_uid')));
            
            Stability(tnum,oneDnum).values(:,oneDnum2)=((fetchn(relSignif ,'stability_odd_even_corr_r','ORDER BY unit_uid')));
            %         Stability_all(tnum,oneDnum).values=nanmedian((fetchn(relAll ,'stability_odd_even_corr_r','ORDER BY unit_uid')));
        end
    end
end

tuning_param_name_1D{1}='lick_horizoffset_relative';
tuning_param_name_1D{2}='lick_peak_x';
tuning_param_name_1D{3}='lick_rt_video_onset';
% Conjunctive tuning  - spatial information
pairs.x(1)=1;
pairs.x(2)=1;
pairs.x(3)=3;

pairs.y(1)=2;
pairs.y(2)=3;
pairs.y(3)=2;

pairs_name.x{1}='lick_horizoffset_relative';
pairs_name.x{2}='lick_horizoffset_relative';
pairs_name.x{3}='lick_rt_video_onset';

pairs_name.y{1}='lick_peak_x';
pairs_name.y{2}='lick_rt_video_onset';
pairs_name.y{3}='lick_peak_x';


% Information
tnum=1;
oneDnum1=1;
for oneDnum2=1:1:numel(tuning_param_name_1D)
    axes('position',[position_x1(4), position_y1(oneDnum2), panel_width1, panel_height1]);
    hold on;
    x=SI(tnum,oneDnum1).values(:,pairs.x(oneDnum2));
    y=SI(tnum,oneDnum1).values(:,pairs.y(oneDnum2));

    plot(x,y,'.','Color', [0 0 0]);

    vname=replace(pairs_name.x{oneDnum2},'_',' ');
    vname=erase(vname,'lick');
    xlabel(vname);
    vname=replace(pairs_name.y{oneDnum2},'_',' ');
    vname=erase(vname,'lick');
    ylabel(vname);
    xl=[0 max([x;y])];
    yl=[0 max([x;y])];

    if oneDnum2==1
    vname=replace(tuning_param_name_1D{oneDnum1},'_',' ');
    vname=erase(vname,'lick');
    title(sprintf('%s \nsignificant t = %.1f \n Information (bits/spike)',vname, time_window_start(tnum) ));
    end
        plot(xl,yl,'-b');
            xlim(xl);
    ylim(yl);
    axis equal;
end

% Stability

tnum=1;
oneDnum1=1;
for oneDnum2=1:1:numel(tuning_param_name_1D)
    axes('position',[position_x1(5), position_y1(oneDnum2), panel_width1, panel_height1]);
    hold on;
    x=Stability(tnum,oneDnum1).values(:,pairs.x(oneDnum2));
    y=Stability(tnum,oneDnum1).values(:,pairs.y(oneDnum2));

    plot(x,y,'.','Color', [0 0 0]);

    vname=replace(pairs_name.x{oneDnum2},'_',' ');
    vname=erase(vname,'lick');
    xlabel(vname);
    vname=replace(pairs_name.y{oneDnum2},'_',' ');
    vname=erase(vname,'lick');
    ylabel(vname);
    xl=[-1 1];
    yl=[-1 1];
  
    if oneDnum2==1
    vname=replace(tuning_param_name_1D{oneDnum1},'_',' ');
    vname=erase(vname,'lick');
    title(sprintf('%s \nsignificant t = %.1f \n Stability r(odd,even)',vname, time_window_start(tnum) ));
    end
        plot([-1 1],[ 0 0],'-b');
                plot([0 0],[ -1 1],'-b');
  xlim(xl);
    ylim(yl);
    axis equal;
end





SI=[];
SI_all=[];
Stability=[];
Stability_all=[];
PROPORTION_signif=[];

%% 1D tuning population

time_window_start=round([-2.8:0.2:1],4);

for tnum=1:1:numel(time_window_start)
    key_time.time_window_start=time_window_start(tnum);
    
    for oneDnum=1:1:numel(tuning_param_name_1D)
        key_1D.tuning_param_name=tuning_param_name_1D{oneDnum};
        rel1= (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance & key_1D & key_time & key & 'number_of_trials>100' & 'total_number_of_spikes_window>100' & 'pvalue_si_1d<=0.01' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
        relSignif_temp=(EPHYS.Unit & 'unit_quality!="multi"') & rel1;
        relSignif=EPHYS.Unit * (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance  & relSignif_temp & key_1D & key_time & key) & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
        relAll=EPHYS.Unit * (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance   & key_1D & key_time & key) & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
        
        SI.mean(tnum,oneDnum)=nanmedian((fetchn(relSignif,'tongue_tuning_1d_si','ORDER BY unit_uid')));
        SI_all.mean(tnum,oneDnum)=nanmedian((fetchn(relAll ,'tongue_tuning_1d_si','ORDER BY unit_uid')));
        
        Stability.mean(tnum,oneDnum)=nanmedian((fetchn(relSignif ,'stability_odd_even_corr_r','ORDER BY unit_uid')));
        Stability_all.mean(tnum,oneDnum)=nanmedian((fetchn(relAll ,'stability_odd_even_corr_r','ORDER BY unit_uid')));
        PROPORTION_signif(tnum,oneDnum)=100*relSignif.count/relAll.count;
    end
end


% Proportion signif
for oneDnum=1:1:numel(tuning_param_name_1D)
    axes('position',[position_x1(oneDnum), position_y1(1), panel_width1, panel_height1]);
    hold on;
    plot([t_go t_go], sz, 'k-','LineWidth',0.75);
    plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
    
    plot(time_window_start,PROPORTION_signif(:,oneDnum)','Color', color2);
    xlabel('Time (s)');
    if oneDnum==1
        ylabel(sprintf('%% signif \n cells'));
    end
    vname=replace(tuning_param_name_1D{oneDnum},'_',' ');
    vname=erase(vname,'lick');
    title(vname);
    yl=[0 max(PROPORTION_signif(:))];
    ylim(yl);
end

% SI summary
for oneDnum=1:1:numel(tuning_param_name_1D)
    axes('position',[position_x1(oneDnum), position_y1(2), panel_width1, panel_height1]);
    hold on;
    hold on;
    plot([t_go t_go], sz, 'k-','LineWidth',0.75);
    plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
    plot(time_window_start,SI_all.mean(:,oneDnum)','Color', color1);
    plot(time_window_start,SI.mean(:,oneDnum)','Color',color2);
    xlabel('Time (s)');
    if oneDnum==1
        ylabel(sprintf('Information \n bits/spike'));
    end
    yl=[0 max(SI.mean(:))];
    ylim(yl);
    %     vname=replace(tuning_param_name_1D{oneDnum},'_',' ');
    %     vname=erase(vname,'lick');
    %     title(vname);
end

% SI summary
for oneDnum=1:1:numel(tuning_param_name_1D)
    axes('position',[position_x1(oneDnum), position_y1(3), panel_width1, panel_height1]);
    hold on;
    hold on;
    plot([t_go t_go], sz, 'k-','LineWidth',0.75);
    plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
    plot(time_window_start,Stability_all.mean(:,oneDnum)','Color', color1);
    plot(time_window_start,Stability.mean(:,oneDnum)','Color',color2);
    xlabel('Time (s)');
    if oneDnum==1
        ylabel(sprintf('Stability \ncorr(odd,even)'));
    end
    yl=[0 max(Stability.mean(:))];
    ylim(yl);
    %     vname=replace(tuning_param_name_1D{oneDnum},'_',' ');
    %     vname=erase(vname,'lick');
    %     title(vname);
end



% ML decoder
for oneDnum=1:1:numel(tuning_param_name_1D)
    axes('position',[position_x1(oneDnum), position_y1(4), panel_width1, panel_height1]);
    key=[];
    key.brain_area='ALM';
%     key.hemisphere='right';
    key.smooth_flag=0;
    key.flag_use_basic_trials=0;
    key.tuning_param_name=tuning_param_name_1D{oneDnum};
    key.outcome_grouping='all';
    hold on;
    plot([t_go t_go], sz, 'k-','LineWidth',0.75);
    plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
    hold on
    x=(fetchn( ANL.TongueMLdecoder&(ANL.SessionPosition& key)&key & 'total_cells_used>=5','mld_time_vector'));
    x=x{1}';
    y_left=(cell2mat(fetchn( ANL.TongueMLdecoder&(ANL.SessionPosition& key)&key & 'total_cells_used>=5','mld_rmse_left_at_t')));
    y_right=(cell2mat(fetchn( ANL.TongueMLdecoder&(ANL.SessionPosition& key)&key & 'total_cells_used>=5','mld_rmse_right_at_t')));
    y_left =mean(y_left-y_left(:,1));
    y_right =mean(y_right-y_right(:,1));
    
    plot(x,smooth(y_left,3),'-r')
    plot(x,smooth(y_right,3),'-b')
    yl(1)=min([y_left,y_right]);
    yl(2)=max([y_left,y_right]);
    
    ylim(yl);
    xlabel('Time (s)');
    if oneDnum==1
        ylabel(sprintf('ML decoder \n RMSE'));
    end
end






%% Save figure

filename = ['population_signficiance_and_decoder'];

dir_save_figure_full=[dir_save_figure];

if isempty(dir(dir_save_figure_full))
    mkdir (dir_save_figure_full)
end
dir_save_figure_full=[dir_save_figure_full '\' filename ];
eval(['print ', dir_save_figure_full, ' -dtiff -cmyk -r200']);
%                 eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);














% % plot distributions for different times
% time_window_start=round([-2.8, -2, -0.2, 0.2, 1],4)
% for tnum=1:1:numel(time_window_start)
%     key_time.time_window_start=time_window_start(tnum);
%
%     for oneDnum=1:1:numel(tuning_param_name_1D)
%         key_1D.tuning_param_name=tuning_param_name_1D{oneDnum};
%         rel1= (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance & key_1D & key_time & key & 'number_of_trials>100' & 'total_number_of_spikes_window>100' & 'pvalue_si_1d<=0.01' )  & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ;
%         relSignif=(EPHYS.Unit & 'unit_quality!="multi"') & rel1;
%
%         TUNING{tnum}.oneD{oneDnum}=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance  & relSignif & key_1D & key_time & key) & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ,'*','ORDER BY unit_uid'));
%         TUNING_ALL{tnum}.oneD{oneDnum}=struct2table(fetch (EPHYS.Unit * (ANL.UnitTongue1DTuning*ANL.UnitTongue1DTuningSignificance  & key_1D & key_time & key) & (EPHYS.UnitCellType*EPHYS.UnitPosition & key ) ,'*','ORDER BY unit_uid'));
%
%         axes('position',[position_x1(oneDnum), position_y1(tnum+2), panel_width1, panel_height1]);
%         set(gca,'defaultAxesColorOrder',[[0.5 0.5 0.5]; [0 1 0]]);
%         bin_edges=linspace(0,1,20);
%         hold on;
%
%         r_all=TUNING_ALL{tnum}.oneD{oneDnum}.stability_odd_even_corr_r;
%         histogram(r_all,bin_edges,'FaceColor',color1);
%         r=TUNING{tnum}.oneD{oneDnum}.stability_odd_even_corr_r;
%         histogram(r,bin_edges,'FaceColor',color2);
%         %         set(gca,'YColor',color2);
%         ylabel('Counts');
%
%         vname=replace(tuning_param_name_1D{oneDnum},'_',' ');
%         vname=erase(vname,'lick');
%         xlabel(vname);
%         if oneDnum==1
%             title(sprintf('t = %.1f',time_window_start(tnum)));
%         end
%
%     end
%
% end
%
%











%
% figure
% key=[];
% key.brain_area='ALM';
% key.hemisphere='left';
% key.outcome_grouping='all';
% key.flag_use_basic_trials=0;
% x=(fetchn( ANL.TongueSVMbinarydecoder &(ANL.SessionPosition& key)&key,'time_vector'));
% x=x{1}';
% y=(cell2mat(fetchn( ANL.TongueSVMbinarydecoder &(ANL.SessionPosition& key)&key,'performance_right_at_t')));
% y=y-y(:,1)
% y=mean(y)
% plot(x,y,'-')



