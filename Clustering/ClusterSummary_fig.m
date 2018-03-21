function ClusterSummary_fig()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Results\\Results\Clustering\'];

%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 20 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
panel_width=0.07;
panel_height=0.08;
horizontal_distance=0.1;
vertical_distance=0.3;

position_x(1)=+0.05;
position_y(1)=0.7;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;

min_cluster_percent=1;

% fetch Param
Param = struct2table(fetch (ANL.Parameters,'*'));
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth_for_clustering',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
t_presample_stim = Param.parameter_value{(strcmp('t_presample_stim',Param.parameter_name))};
t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
t_earlydelay_stim = Param.parameter_value{(strcmp('t_earlydelay_stim',Param.parameter_name))};
t_latedelay_stim = Param.parameter_value{(strcmp('t_latedelay_stim',Param.parameter_name))};

% fetch Cluster
rel_cluster = (ANL.UnitHierarCluster * EPHYS.Unit) & 'hemisphere="both"' & 'brain_area="ALM"' & 'cell_type="Pyr"' & 'unit_quality="good"' & 'training_type="regular"';
key_cluster = fetch(rel_cluster);
UnitCluster  = struct2table(fetch(rel_cluster,'*', 'ORDER BY unit_uid'));
key_cluster = rmfield(key_cluster,{'hemisphere','brain_area','cell_type','unit_quality','training_type','heirar_cluster_time_st','heirar_cluster_time_end'});
idx_time2plot = (time>= UnitCluster.heirar_cluster_time_st(1)) & (time<=UnitCluster.heirar_cluster_time_end(1)+1);
time2plot = time(idx_time2plot);


% fetch PSTH
PSTH_L = cell2mat(fetchn(((ANL.PSTHAdaptiveAverage * EPHYS.Unit) & key_cluster) & 'outcome="hit"' & 'trial_type_name="l"', 'psth_avg', 'ORDER BY unit_uid'));
PSTH_R =  cell2mat(fetchn(((ANL.PSTHAdaptiveAverage * EPHYS.Unit) & key_cluster) & 'outcome="hit"' & 'trial_type_name="r"', 'psth_avg', 'ORDER BY unit_uid'));

%smoothing
PSTH_L = movmean(PSTH_L, [smooth_bins 0], 2, 'Endpoints','shrink');
PSTH_R = movmean(PSTH_R, [smooth_bins 0], 2, 'Endpoints','shrink');

% Select cluster to plot
cl_id=UnitCluster.heirar_cluster_id;
cluster_percent=100*histcounts(cl_id,1:1:numel(unique(cl_id))+1)/numel(cl_id);
clusters_2plot = find(cluster_percent>=min_cluster_percent);
n_clust_2plot = numel (clusters_2plot);
[~,cluster_order] = sort (cluster_percent(clusters_2plot),'descend');



plot_counter=0;
for ii = cluster_order
    i = clusters_2plot(ii);
    idx2plot = find(cl_id==i);
    L_clu.m=mean(PSTH_L(idx2plot,idx_time2plot),1);
    L_clu.stem=std(PSTH_L(idx2plot,idx_time2plot),1)./sqrt(numel(idx2plot));
    R_clu.m=mean(PSTH_R(idx2plot,idx_time2plot),1);
    R_clu.stem=std(PSTH_R(idx2plot,idx_time2plot),1)./sqrt(numel(idx2plot));
    peak_FR = max([L_clu.m+L_clu.stem,R_clu.m+R_clu.stem]);
    
    %     LR_cluster =   squeeze(nanmean(psth_LR_cells(i2plot,:,:),1));
    
    
    %% Cluster Pure L vs Pure R PSTH
    %     abs_peak = nanmax(nanmax(LR_cluster(:,t_select)));
    %     abs_min = nanmin(nanmin(LR_cluster(:,t_select)));
    plot_counter = plot_counter +1;
    axes('position',[position_x(1)+horizontal_distance*(mod((plot_counter)+eps,9)), position_y(ceil(plot_counter/9)), panel_width, panel_height]);
    hold on;
    
    plot([t_go t_go], [0 100], 'k-','LineWidth',2);
    plot([t_chirp1 t_chirp1], [0 100], 'k--','LineWidth',0.75);
    plot([t_chirp2 t_chirp2], [0 100], 'k--','LineWidth',0.75);
    
    title(sprintf('%.1f %% of cells \n',cluster_percent(i)),'FontSize',7);
    xlabel(sprintf('Time (s)\n'));
    %     ylabel('FR (normal.)');
    shadedErrorBar(time2plot,L_clu.m,L_clu.stem,'lineprops',{'r-','markerfacecolor','r','linewidth',1});
    shadedErrorBar(time2plot,R_clu.m,R_clu.stem,'lineprops',{'b-','markerfacecolor','b','linewidth',1},'transparent',1);
    xlim([time2plot(1), time2plot(end)]);
    ylim([0,peak_FR*1.05]);
    
    
    %     plot(time2plot,L_cluster,'color',[1 0 0],'linewidth',2);
    %     plot(time2plot,R_cluster,'color',[0 0 1],'linewidth',2);
    %     sz(1)= abs_min;
    %     sz(2)= abs_peak;
    %     plot([GP.chirp2tm,GP.chirp2tm], sz,'--k');
    %     set(gca,'xtick',[ -2, -1, 0],'ylim',[sz],'ytick',[sz],'tickdir','out','ticklength',[.04 .04],'fontsize',6)
    %     tix=get(gca,'ytick')';
    %     set(gca,'yticklabel',num2str(tix,'%.1f'))
        plot([-2.5,-2.5+0.4], [peak_FR*1.15,peak_FR*1.15],'-','linewidth',3,'color',[0 0 1],'Clipping','off');
    box off;
    
    
end



end