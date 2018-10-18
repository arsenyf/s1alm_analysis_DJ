function analysis_tongue_tuning_population_venn_diagram()
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
position_x1(3)=position_x1(2)+horizontal_distance1;

position_y1(1)=0.8;
position_y1(2)=position_y1(1)-vertical_distance1;
position_y1(3)=position_y1(2)-vertical_distance1;


key.brain_area='ALM';
% key.hemisphere='right';
key.cell_type='Pyr';
key.outcome_grouping='all';
key.flag_use_basic_trials=0;
key.smooth_flag=0;

tuning_param_name{1}='lick_horizoffset';
tuning_param_name{2}='lick_peak_x';
tuning_param_name{3}='lick_rt_video_onset';

tuning_param_label{1}='ML';
tuning_param_label{2}='AP';
tuning_param_label{3}='RT';

lick_direction_name{1}='all';
lick_direction_name{2}='right';
lick_direction_name{3}='left';

time_window_start=([-0.2, 0]);

% c=distinguishable_colors(8);
colr{1}=[1.0000    0.8276         0];
colr{2}=[ 0    1.0000         0.5];
colr{3}=[0.5000         0    0.5000];

rel_total=(EPHYS.Unit & 'unit_quality!="multi"')*EPHYS.UnitCellType*EPHYS.UnitPosition & key & ANL.UnitTongue1DTuning;

for i_t=1:1:numel(time_window_start)
    for i_d=1:1:numel(lick_direction_name)
        for oneDnum=1:1:numel(tuning_param_name)
            
            key.tuning_param_name=tuning_param_name{oneDnum};
            key.lick_direction=lick_direction_name{i_d};  %ANL.LickDirectionType
            
            
            key.time_window_start=round(time_window_start(i_t),4);
            
            relSignif{oneDnum} = fn_fetch_significant_cells (key);
            
        end
        
        % VENN-Diagram 1
        %--------------------------------------------------------------------------
        
        a=relSignif{1}; %a=a.proj; %taking only the primary keys using projection operator
        b=relSignif{2}; %b=b.proj;
        c=relSignif{3}; %c=c.proj;
        
        a_b=a & proj(b);
        a_c=a & proj(c);
        b_c=b & proj(c);
        a_b_c=a & proj(b) & proj(c);
        
        venn_groups = [a.count b.count c.count];
        venn_intersections = [a_b.count a_c.count b_c.count a_b_c.count];
        
        
        hh=axes('position',[position_x1(i_d), position_y1(i_t), panel_width1, panel_height1]);
        
        [H, S]=venn(venn_groups,venn_intersections,'FaceColor',{colr{1},colr{2},colr{3}});
        hh=gca;
        axis equal;
        axis off
        
        Percentage=100*S.ZonePop./rel_total.count;
        
        for i = 1:length(S.ZoneCentroid)
            text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), sprintf('%.1f %%',Percentage(i)),'FontSize',7,'HorizontalAlignment','center');
        end
        title(sprintf('%s licks,  t = %.1f',key.lick_direction, key.time_window_start))
        xl=get(hh,'xlim'); yl =get(hh,'ylim');
        
        text(xl(1)+diff(xl)*0.1,  yl(1)-diff(yl)*0.2,  tuning_param_label{1},'Color', colr{1})
        text(xl(1)+diff(xl)*0.4,  yl(1)-diff(yl)*0.2,  tuning_param_label{2},'Color', colr{2})
        text(xl(1)+diff(xl)*0.7,  yl(1)-diff(yl)*0.2,  tuning_param_label{3},'Color', colr{3})
        
    end
end



if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
filename=['tuning_venn'];
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
