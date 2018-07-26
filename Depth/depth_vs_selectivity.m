function depth_vs_selectivity()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Population\Depth\'];


key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'all'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
k=key;

if contains(k.hemisphere, 'both')
    k = rmfield(k,'hemisphere')
end
if contains(k.training_type, 'all')
    k = rmfield(k,'training_type')
end

if contains(k.unit_quality, 'ok or good')
    k = rmfield(k,'unit_quality')
    rel_Selectivity =((EXP.Session * EXP.SessionID * ANL.Selectivity * EPHYS.Unit * EPHYS.UnitPosition *   EPHYS.UnitCellType * EXP.SessionTraining    *  ANL.IncludeSession ) ) & k & 'unit_quality!="multi"' & ANL.IncludeUnit;
else
    rel_Selectivity =((EXP.Session * EXP.SessionID * ANL.Selectivity * EPHYS.Unit * EPHYS.UnitPosition *   EPHYS.UnitCellType * EXP.SessionTraining    *  ANL.IncludeSession ) ) & k & ANL.IncludeUnit;
end


%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
panel_width=0.2;
panel_height=0.2;
horizontal_distance=0.3;
vertical_distance=0.3;

position_x(1)=0.05;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;
position_x(7)=position_x(6)+horizontal_distance;
position_x(8)=position_x(7)+horizontal_distance;

position_y(1)=0.7;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;


Param = struct2table(fetch (ANL.Parameters,'*'));
t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};

time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth_for_clustering',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
idx_time2plot = (time>= -2.5 & time<=1);
time2plot = time(idx_time2plot);



unit_selectivity = movmean(cell2mat(fetchn(rel_Selectivity,'unit_selectivity','ORDER BY unit_uid')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
unit_selectivity = unit_selectivity(:,idx_time2plot);
[max_abs_selectivity, t_max_idx ] = max(abs(unit_selectivity),[],2);
for i =1:1:numel(max_abs_selectivity)
    max_selectivity(i,1) = unit_selectivity(i,t_max_idx(i));
end

idx_left_selective =max_selectivity<0;
idx_right_selective = max_selectivity>0;

t_max = time2plot(t_max_idx);

mean_fr_sample_delay = fetchn(rel_Selectivity * ANL.UnitFiringRate,'mean_fr_sample_delay','ORDER BY unit_uid');

%  max_selectivity=max_selectivity./mean_fr_sample_delay;

depth = fetchn(rel_Selectivity,'unit_dv_location','ORDER BY unit_uid')


% Selectivity max. time and  and depth
%% all
axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
plot(t_max,max_selectivity,'.')
xlabel('Time(s)');
ylabel(' Max. Selectivity (Hz)');
ylim([min(max_selectivity),max(max_selectivity)]);
title('All cells');

axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
plot(depth,t_max,'.')
xlabel(' Depth (um)');
ylabel('Time of max selectivity (s)');
xlim([min(depth),max(depth)]);

axes('position',[position_x(3), position_y(1), panel_width, panel_height]);
plot(depth,max_selectivity,'.')
xlabel(' Depth (um)');
ylabel('Max selectivity (Hz)');
xlim([min(depth),max(depth)]);
ylim([min(max_selectivity),max(max_selectivity)]);

%% right prefering
axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
plot(t_max(idx_right_selective),max_selectivity(idx_right_selective),'.')
xlabel('Time(s)');
ylabel(' Max. Selectivity (Hz)');
ylim([min(max_selectivity(idx_right_selective)),max(max_selectivity(idx_right_selective))]);
title('Right-preferring cells');

axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
plot(depth(idx_right_selective),t_max(idx_right_selective),'.')
xlabel(' Depth (um)');
ylabel('Time of max selectivity (s)');
xlim([min(depth(idx_right_selective)),max(depth(idx_right_selective))]);

axes('position',[position_x(3), position_y(2), panel_width, panel_height]);
plot(depth(idx_right_selective),max_selectivity(idx_right_selective),'.')
xlabel(' Depth (um)');
ylabel('Max selectivity (Hz)');
xlim([min(depth(idx_right_selective)),max(depth(idx_right_selective))]);
ylim([min(max_selectivity(idx_right_selective)),max(max_selectivity(idx_right_selective))]);

%% left prefering
axes('position',[position_x(1), position_y(3), panel_width, panel_height]);
plot(t_max(idx_left_selective),max_selectivity(idx_left_selective),'.')
xlabel('Time(s)');
ylabel(' Max. Selectivity (Hz)');
ylim([min(max_selectivity(idx_left_selective)),max(max_selectivity(idx_left_selective))]);
title('Left-preferring cells');

axes('position',[position_x(2), position_y(3), panel_width, panel_height]);
plot(depth(idx_left_selective),t_max(idx_left_selective),'.')
xlabel(' Depth (um)');
ylabel('Time of max selectivity (s)');
xlim([min(depth(idx_left_selective)),max(depth(idx_left_selective))]);

axes('position',[position_x(3), position_y(3), panel_width, panel_height]);
plot(depth(idx_left_selective),max_selectivity(idx_left_selective),'.')
xlabel(' Depth (um)');
ylabel('Max selectivity (Hz)');
xlim([min(depth(idx_left_selective)),max(depth(idx_left_selective))]);
ylim([min(max_selectivity(idx_left_selective)),max(max_selectivity(idx_left_selective))]);

if contains(key.unit_quality, 'ok or good')
    key.unit_quality = 'ok';
end

filename =[sprintf('%s%s_Training_%s_UnitQuality_%s_Type_%s' ,key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type)];

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);



end




