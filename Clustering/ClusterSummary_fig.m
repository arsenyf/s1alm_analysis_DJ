function ClusterSummary_fig()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root '\Results\Clustering\'];

%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 23 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
panel_width=0.05;
panel_height=0.065;
horizontal_distance=0.075;
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
key.training_type = 'distractor'
key.unit_quality = 'ok or good' %'ok or good'
key.cell_type = 'FS'


k = key;
if contains(k.unit_quality,'all')
   k = rmfield(k,'unit_quality');
end

rel_unit=(EPHYS.Unit);
rel_cluster = (ANL.UnitHierarCluster * rel_unit.proj('unit_quality->temp','unit_uid')) & k;
key_cluster = fetch(rel_cluster);
UnitCluster  = struct2table(fetch(rel_cluster,'*', 'ORDER BY unit_uid'));
key_cluster = rmfield(key_cluster,{'hemisphere','brain_area','cell_type','unit_quality','training_type','heirar_cluster_time_st','heirar_cluster_time_end'});
idx_time2plot = (time>= UnitCluster.heirar_cluster_time_st(1)) & (time<=UnitCluster.heirar_cluster_time_end(1));
time2plot = time(idx_time2plot);

%fetch Unit
Unit = struct2table(fetch((EPHYS.Unit * EPHYS.UnitPosition * EXP.SessionTraining * EXP.SessionID) & key_cluster,'*', 'ORDER BY unit_uid'));
session_uid = unique(Unit.session_uid);

L.labels = {'hit','miss','ignore'};
R.labels = {'hit','miss','ignore'};

%% Hit
% fetch and smooth PSTH
rel= ((ANL.PSTHAverageLR * EPHYS.Unit) & key_cluster) & 'outcome="hit"';
L.PSTH{1} = movmean(cell2mat(fetchn(rel  & 'trial_type_name="l"', 'psth_avg', 'ORDER BY unit_uid')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
R.PSTH{1} = movmean(cell2mat(fetchn(rel  & 'trial_type_name="r"', 'psth_avg', 'ORDER BY unit_uid')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');

L.num_trials{1} = (fetchn(rel  & 'trial_type_name="l"', 'num_trials_averaged', 'ORDER BY unit_uid'));
R.num_trials{1} = (fetchn(rel  & 'trial_type_name="r"', 'num_trials_averaged', 'ORDER BY unit_uid'));

peak_LR_hit_units = nanmax([L.PSTH{1},R.PSTH{1}],[],2);

%% Miss
% fetch and smooth PSTH
rel= ((ANL.PSTHAverageLR * EPHYS.Unit) & key_cluster) & 'outcome="miss"';
L.PSTH{2} = movmean(cell2mat(fetchn(rel  & 'trial_type_name="l"', 'psth_avg', 'ORDER BY unit_uid')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
R.PSTH{2} = movmean(cell2mat(fetchn(rel  & 'trial_type_name="r"', 'psth_avg', 'ORDER BY unit_uid')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
L.num_trials{2} = (fetchn(rel  & 'trial_type_name="l"', 'num_trials_averaged', 'ORDER BY unit_uid'));
R.num_trials{2} = (fetchn(rel  & 'trial_type_name="r"', 'num_trials_averaged', 'ORDER BY unit_uid'));


%% Ignore
% fetch and smooth PSTH
rel= ((ANL.PSTHAverageLR * EPHYS.Unit) & key_cluster) & 'outcome="ignore"';
L.PSTH{3} = movmean(cell2mat(fetchn(rel  & 'trial_type_name="l"', 'psth_avg', 'ORDER BY unit_uid')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
R.PSTH{3} = movmean(cell2mat(fetchn(rel  & 'trial_type_name="r"', 'psth_avg', 'ORDER BY unit_uid')) ,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
L.num_trials{3} = (fetchn(rel  & 'trial_type_name="l"', 'num_trials_averaged', 'ORDER BY unit_uid'));
R.num_trials{3} = (fetchn(rel  & 'trial_type_name="r"', 'num_trials_averaged', 'ORDER BY unit_uid'));



% Select cluster to plot
cl_id=UnitCluster.heirar_cluster_id;
cluster_percent=100*histcounts(cl_id,1:1:numel(unique(cl_id))+1)/numel(cl_id);
clusters_2plot = find(cluster_percent>=min_cluster_percent);
[~,cluster_order] = sort (cluster_percent(clusters_2plot),'descend');
cluster_order=cluster_order(1:min([numel(clusters_2plot),columns2plot*2]));

axes('position',[position_x(1), 0.93, panel_width, panel_height]);
percent_of_all = sum(cluster_percent(clusters_2plot));
text( 0,0 , sprintf('%s %s side   Training: %s    CellQuality: %s  Cell-type: %s    \n \n Includes: %d units,   %.1f %% in these clusters:' ,...
    key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type, size(UnitCluster,1), percent_of_all),'HorizontalAlignment','Left','FontSize', 10);
axis off;
box off;

plot_counter=0;
for ii = cluster_order
    i = clusters_2plot(ii);
    idx2plot = find(cl_id==i);
    
    %% Percent cells in different hemispheres, for each cluster (mean/stem across sessions)
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)+0.1, panel_width, panel_height*0.6]);
    for i_suid = 1:1:numel(session_uid)
        idx_in_session = find(Unit.session_uid == session_uid(i_suid));
        cells_in_Session (i_suid) = numel(idx_in_session);
        cluster_percent_in_session(i_suid) =     100*sum(ismember(idx_in_session,idx2plot))/numel(idx_in_session);
        session_hemis(i_suid) = Unit.hemisphere(idx_in_session(1));
    end
    L_percent = cluster_percent_in_session(contains(session_hemis,'left') & cells_in_Session>=0);
    HemisL.mean=mean(L_percent);
    HemisL.stem=std(L_percent)/sqrt(numel(L_percent));
    
    R_percent = cluster_percent_in_session(contains(session_hemis,'right') & cells_in_Session>=0);
    if (~isempty (L_percent) && ~isempty (R_percent)) %i.e. if there are recordings from both left and right hemispheres
        HemisR.mean=mean(R_percent);
        HemisR.stem=std(R_percent)/sqrt(numel(R_percent));
        pvalue_HemisLR = ranksum(L_percent,R_percent); %Wilcoxon rank sum test (non paired-samples)
        %     [~, pvalue_HemisLR]= ttest2(L_percent,R_percent); %Wilcoxon rank sum test (non paired-samples)
        if pvalue_HemisLR<=0.001
            pvalue_star='***';
        elseif pvalue_HemisLR<=0.01
            pvalue_star='**';
        elseif pvalue_HemisLR <=0.05
            pvalue_star='*';
        else
            pvalue_star='';
        end
        
        hold on;
        bar(1,HemisL.mean,'facecolor',[1 0 0],'edgecolor', [1 0 0], 'BarWidth', 0.7);
        bar(2,HemisR.mean,'facecolor',[0 0 1],'edgecolor', [0 0 1], 'BarWidth', 0.7);
        errorbar_myown( [1 2], [HemisL.mean HemisR.mean], [0 0], [HemisL.stem HemisR.stem],  '.k', 0.1 );
        xlim([0 3]);
        ylim([0 max([HemisL.mean+HemisL.stem, HemisR.mean+ HemisR.stem,eps])]);
        text(2,max([(HemisR.mean+ HemisR.stem)*1.2, 1]),pvalue_star,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
        set(gca,'xtick',[1,2],'xticklabels',{'L','R'},'FontSize',8);
        if mod(plot_counter,columns2plot)==0
            ylabel(sprintf('%% cells in\n   hemisphere'),'FontSize',9);
        end
    end
    title(sprintf('Cluster %d \n %.1f %% cells\n',plot_counter+1, cluster_percent(i) ),'FontSize',8);
    
    %% Cluster Pure L vs Pure R PSTH
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1), panel_width, panel_height]);
    flag_xlabel=0;
    ylab='Correct'; num=1;
    legend_flag=1;
    [peak_FR] = fn_plotCluster (plot_counter, columns2plot, Param,time2plot, idx2plot, idx_time2plot,  L, R, num, [], flag_xlabel, peak_LR_hit_units,ylab, legend_flag);
    
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)-0.1, panel_width, panel_height]);
    flag_xlabel=0;
    ylab='Error'; num=2;
    legend_flag=1;
    [~] = fn_plotCluster (plot_counter, columns2plot, Param,time2plot, idx2plot, idx_time2plot,  L, R, num, peak_FR, flag_xlabel, peak_LR_hit_units,ylab, legend_flag);
    
    axes('position',[position_x(1)+horizontal_distance*(mod(plot_counter,columns2plot)), position_y(floor(plot_counter/columns2plot)+1)-0.2, panel_width, panel_height]);
    flag_xlabel=1;
    ylab='No lick'; num=3;
    legend_flag=1;
    [~] = fn_plotCluster (plot_counter, columns2plot, Param,time2plot, idx2plot, idx_time2plot,  L, R, num, peak_FR,flag_xlabel, peak_LR_hit_units,ylab, legend_flag);
    
    plot_counter = plot_counter +1;
    
end

if contains(key.unit_quality, 'ok or good')
    key.unit_quality = 'ok';
end

filename =[sprintf('%s%s_Training_%s_UnitQuality_%s_Type_%s__clusters' ,key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type)];

if isempty(dir(dir_save_figure))
    mkdir (dir_save_figure)
end
figure_name_out=[ dir_save_figure filename];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r200']);
eval(['print ', figure_name_out, ' -dpdf -cmyk -r200']);

end