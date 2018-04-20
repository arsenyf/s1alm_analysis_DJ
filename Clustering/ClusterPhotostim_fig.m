function ClusterPhotostim_fig()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root '\Results\Clustering\Photostim\'];

%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
panel_width=0.048;
panel_height=0.065;
horizontal_distance=0.07;
vertical_distance=0.45;

position_x(1)=0.065;
position_y(1)=0.7;
position_y(2)=position_y(1)-vertical_distance;


columns2plot=12;
min_cluster_percent=1;

% fetch Param
Param = struct2table(fetch (ANL.Parameters,'*'));
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth_for_clustering',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);

% fetch Cluster
key.brain_area = 'ALM'
key.hemisphere = 'both'
key.training_type = 'regular'
key.unit_quality = 'ok or good' %'ok or good'
key.cell_type = 'FS'
condition = 'full_late'
if strcmp(condition,'mini')
    key.session_flag_mini = 1;
    key_trialtype.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    key.session_flag_full = 1;
    key_trialtype.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
    key.session_flag_full_late = 1;
    key_trialtype.trialtype_flag_full_late = 1;
end


k = key;
if contains(k.unit_quality,'all')
    k = rmfield(k,'unit_quality');
end

rel_unit=(EPHYS.Unit * ANL.SessionGrouping);
rel_cluster = (ANL.UnitHierarCluster * rel_unit.proj('unit_quality->temp','unit_uid')) & k;
key_cluster = fetch(rel_cluster);
UnitCluster  = struct2table(fetch(rel_cluster,'*', 'ORDER BY unit_uid'));
key_cluster = rmfield(key_cluster,{'hemisphere','brain_area','cell_type','unit_quality','training_type','heirar_cluster_time_st','heirar_cluster_time_end'});
idx_time2plot = (time>= UnitCluster.heirar_cluster_time_st(1)-0.51) & (time<=UnitCluster.heirar_cluster_time_end(1));
time2plot = time(idx_time2plot);

%fetch Unit
Unit = struct2table(fetch((EPHYS.Unit * EPHYS.UnitPosition * EXP.SessionTraining * EXP.SessionID) & key_cluster,'*', 'ORDER BY unit_uid'));
session_uid = unique(Unit.session_uid);

L.labels = {'hit','miss','ignore'};
R.labels = {'hit','miss','ignore'};

%% Hit
% fetch and smooth PSTH
rel1= ((ANL.PSTHAverage * EPHYS.Unit) & key_cluster) & 'outcome="hit"';
L.PSTH{1} = movmean(cell2mat(fetchn(rel1  & 'trial_type_name="l"', 'psth_avg', 'ORDER BY unit_uid')) ,[smooth_bins 0], 2, 'Endpoints','shrink');
R.PSTH{1} = movmean(cell2mat(fetchn(rel1  & 'trial_type_name="r"', 'psth_avg', 'ORDER BY unit_uid')) ,[smooth_bins 0], 2, 'Endpoints','shrink');

L.num_trials{1} = (fetchn(rel1  & 'trial_type_name="l"', 'num_trials_averaged', 'ORDER BY unit_uid'));
R.num_trials{1} = (fetchn(rel1  & 'trial_type_name="r"', 'num_trials_averaged', 'ORDER BY unit_uid'));

peak_LR_hit_units = nanmax([L.PSTH{1},R.PSTH{1}],[],2);

%% Photostim
% fetch and smooth PSTH
rel2 = (EPHYS.Unit * ANL.PSTHAverage * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction  * ANL.TrialTypeStimTime)  & key_cluster & 'outcome="hit"' & key_trialtype;
PSTH_hit = struct2table(fetch(rel2,'*', 'ORDER BY unit_uid'));

rel3 = (EPHYS.Unit * ANL.PSTHAverage * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction  * ANL.TrialTypeStimTime)  & key_cluster & 'outcome="miss"' & key_trialtype;
PSTH_miss = struct2table(fetch(rel3,'*', 'ORDER BY unit_uid'));

rel4 = (EPHYS.Unit * ANL.PSTHAverage * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction  * ANL.TrialTypeStimTime)  & key_cluster & 'outcome="ignore"' & key_trialtype;
PSTH_ignore = struct2table(fetch(rel4,'*', 'ORDER BY unit_uid'));


% Select cluster to plot
cl_id=UnitCluster.heirar_cluster_id;
cluster_percent=100*histcounts(cl_id,1:1:numel(unique(cl_id))+1)/numel(cl_id);
clusters_2plot = find(cluster_percent>=min_cluster_percent);
[~,cluster_order] = sort (cluster_percent(clusters_2plot),'descend');
cluster_order=cluster_order(1:min([numel(clusters_2plot),columns2plot]));

axes('position',[position_x(1), 0.93, panel_width, panel_height]);
percent_of_all = sum(cluster_percent(clusters_2plot));
text( 0,0 , sprintf('%s %s side   Training: %s    CellQuality: %s  Cell-type: %s    \n \n Includes: %d units,   %.1f %% in these clusters:' ,...
    key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type, size(UnitCluster,1), percent_of_all),'HorizontalAlignment','Left','FontSize', 10);
axis off;
box off;

plot_counter=0;
for ii = cluster_order
    i = clusters_2plot(ii);
    idx2plot = find(cl_id==i); % from the units list
    
    %% Percent cells in different hemispheres, for each cluster (mean/stem across sessions)
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)+0.08, panel_width, panel_height*0.6]);
    title(sprintf('Cluster %d \n %.1f %% cells\n',plot_counter+1, cluster_percent(i) ),'FontSize',8);
    axis off;
    
    % Plot trial-type legends
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)+0.07, panel_width, panel_height]);
    trialtype_uid = unique(PSTH_hit.trialtype_uid);
    fn_plot_trial_legend (trialtype_uid);
    xlim([time2plot(1), time2plot(end)]);
    
    %% Cluster Pure L vs Pure R PSTH
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1), panel_width, panel_height]);
    flag_xlabel=0;
    ylab='Correct'; num=1;
    legend_flag=0;
    [peak_FR] = fn_plotCluster (plot_counter, columns2plot, Param,time2plot, idx2plot, idx_time2plot,  L, R, num, [], flag_xlabel, peak_LR_hit_units,ylab, legend_flag);
    
    
    PSTHhitc=PSTH_hit(ismember(PSTH_hit.unit_uid, UnitCluster.unit_uid(idx2plot)),:);
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)-0.1, panel_width, panel_height]);
    flag_xlabel=0;
    ylab='Right, correct';
    fn_plotClusterPhotostim (plot_counter, columns2plot,PSTHhitc, Param, 'right',peak_LR_hit_units(idx2plot),flag_xlabel,ylab,time2plot);
    
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)-0.2, panel_width, panel_height]);
    flag_xlabel=0;
    ylab='Left, correct';
    fn_plotClusterPhotostim (plot_counter, columns2plot,PSTHhitc, Param, 'left',peak_LR_hit_units(idx2plot),flag_xlabel,ylab,time2plot);
    
    PSTHmissc=PSTH_miss(ismember(PSTH_miss.unit_uid, UnitCluster.unit_uid(idx2plot)),:);
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)-0.3, panel_width, panel_height]);
    flag_xlabel=0;
    ylab='Right, error';
    fn_plotClusterPhotostim (plot_counter, columns2plot,PSTHmissc, Param, 'right',peak_LR_hit_units(idx2plot),flag_xlabel,ylab,time2plot);
    
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)-0.4, panel_width, panel_height]);
    flag_xlabel=0;
    ylab='Left, error';
    fn_plotClusterPhotostim (plot_counter, columns2plot,PSTHmissc, Param, 'left',peak_LR_hit_units(idx2plot),flag_xlabel,ylab,time2plot);
    
    PSTHignorec=PSTH_ignore(ismember(PSTH_ignore.unit_uid, UnitCluster.unit_uid(idx2plot)),:);
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)-0.5, panel_width, panel_height]);
    flag_xlabel=0;
    ylab='Right, no-lick';
    fn_plotClusterPhotostim (plot_counter, columns2plot,PSTHignorec, Param, 'right',peak_LR_hit_units(idx2plot),flag_xlabel,ylab,time2plot);
    
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)-0.6, panel_width, panel_height]);
    flag_xlabel=0;
    ylab='Left, no-lick';
    fn_plotClusterPhotostim (plot_counter, columns2plot,PSTHignorec, Param, 'left',peak_LR_hit_units(idx2plot),flag_xlabel,ylab,time2plot);
    
    plot_counter = plot_counter +1;
    
end

if contains(key.unit_quality, 'ok or good')
    key.unit_quality = 'ok';
end

filename =[sprintf('%s%s_Training_%s_UnitQuality_%s_Type_%s_Stimulus_%s' ,key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type, condition)];

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
% eval(['print ', figure_name_out, ' -opengl -dpdf -cmyk -r200']);
eval(['print ', figure_name_out, ' -opengl -dtiff -cmyk -r400']);
% eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
% eval(['print ', figure_name_out, ' -painters -dtiff -cmyk -r200']);
end