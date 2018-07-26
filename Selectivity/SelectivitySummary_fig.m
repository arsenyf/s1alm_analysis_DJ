function SelectivitySummary_fig()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root '\Results\Selectivity\'];

key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'regular'
key.unit_quality = 'ok or good'  %'ok or good'
key.cell_type = 'Pyr'

%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
panel_width=0.15;
panel_height=0.06;
horizontal_distance=0.075;
vertical_distance=0.135;

position_x(1)=0.2;
position_y(1)=0.8;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;
position_y(6)=position_y(5)-vertical_distance;


columns2plot=12;
min_cluster_percent=1.5;

% fetch Param
Param = struct2table(fetch (ANL.Parameters,'*'));
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth_for_clustering',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);

% fetch Cluster

k = key;
if contains(key.hemisphere, 'both')
    k= rmfield(k,'hemisphere');
end
if contains(key.training_type, 'all')
    k= rmfield(k,'training_type');
end

if contains(key.unit_quality, 'ok or good')
    k= rmfield(k,'unit_quality');
    rel=(EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAdaptiveAverage) & ANL.IncludeUnit & k & 'unit_quality!="multi"';
    key.unit_quality = 'ok';
else
    rel=(EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAdaptiveAverage) & ANL.IncludeUnit & k & 'unit_quality!="multi"';
end

rel=(EPHYS.Unit * EXP.SessionTraining * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.PSTHAdaptiveAverage) & ANL.IncludeUnit & k;

%fetch Unit
%% Hit
% fetch and smooth PSTH
PSTH_L_hit = movmean(cell2mat(fetchn((rel & k) & 'outcome="hit"' & 'trial_type_name="l"', 'psth_avg', 'ORDER BY unit_uid')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
PSTH_R_hit =   movmean(cell2mat(fetchn((rel & k) & 'outcome="hit"' & 'trial_type_name="r"', 'psth_avg', 'ORDER BY unit_uid')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');

axes('position',[position_x(1), 0.89, panel_width, panel_height]);
text( 0,0 , sprintf('%s %s side   Training: %s    CellQuality: %s  Cell-type: %s    \n ' ,...
    key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type),'HorizontalAlignment','Left','FontSize', 12);
axis off;
box off;


%% Cluster Pure L vs Pure R PSTH
axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
flag='';
fn_plotSpikeCount (Param,time, PSTH_L_hit ,PSTH_R_hit,'FR',flag)

axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
flag='Normalized';
fn_plotSpikeCount (Param,time, PSTH_L_hit ,PSTH_R_hit,'FR',flag)


axes('position',[position_x(1), position_y(3), panel_width, panel_height]);
flag='';
fn_plotSelectivity (Param,time, PSTH_L_hit ,PSTH_R_hit,'Selectiviy',flag)

axes('position',[position_x(1), position_y(4), panel_width, panel_height]);
flag='absolute'; %and normalized
fn_plotSelectivity (Param,time, PSTH_L_hit ,PSTH_R_hit,'Selectiviy',flag)

axes('position',[position_x(1), position_y(5), panel_width, panel_height]);
flag='positive'; %and normalized
fn_plotSelectivity (Param,time, PSTH_L_hit ,PSTH_R_hit,'Selectiviy',flag)

axes('position',[position_x(1), position_y(6), panel_width, panel_height]);
flag='negative'; %and normalized
fn_plotSelectivity (Param,time, PSTH_L_hit ,PSTH_R_hit,'Selectiviy',flag)



filename =[sprintf('%s%s_Training_%s_UnitQuality_%s_Type_%s__selectivity' ,key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type)];

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r200']);
eval(['print ', figure_name_out, ' -dpdf -cmyk -r100']);

end