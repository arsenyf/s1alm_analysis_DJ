function [peak_FR]=fn_plotCluster (plot_counter, columns2plot, Param,time2plot,idx2plot, idx_time2plot,  L, R, num, peak_FR,  flag_xlabel, peak_LR_hit_units, ylab,legend_flag)
peak_FR=[];

t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
t_presample_stim = Param.parameter_value{(strcmp('t_presample_stim',Param.parameter_name))};
t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
t_earlydelay_stim = Param.parameter_value{(strcmp('t_earlydelay_stim',Param.parameter_name))};
t_latedelay_stim = Param.parameter_value{(strcmp('t_latedelay_stim',Param.parameter_name))};

min_trials = Param.parameter_value{(strcmp('mintrials_heirarclusters',Param.parameter_name))};

include_units= find(L.num_trials{num} >=min_trials & R.num_trials{num} >=min_trials);
idx2plot = intersect(idx2plot,include_units);
if isempty(idx2plot)
    return
end
PSTH_L = L.PSTH{num};
PSTH_R= R.PSTH{num};

% PSTH_L = PSTH_L./peak_LR_hit_units;
% PSTH_R = PSTH_R./peak_LR_hit_units;


L_clu.m=nanmean(PSTH_L(idx2plot,idx_time2plot),1);
L_clu.stem=nanstd(PSTH_L(idx2plot,idx_time2plot),1)./sqrt(numel(idx2plot));
R_clu.m=nanmean(PSTH_R(idx2plot,idx_time2plot),1);
R_clu.stem=nanstd(PSTH_R(idx2plot,idx_time2plot),1)./sqrt(numel(idx2plot));

if numel(idx2plot)==1
    L_clu.stem = L_clu.m*0;
    R_clu.stem = R_clu.m*0;
end

if isempty(peak_FR)
    peak_FR = nanmax([L_clu.m+L_clu.stem,R_clu.m+R_clu.stem]);
end

% xlim([time2plot(1), time2plot(end)]);
xl=([-3.5  2]);
xlim(xl);
yl=([0,peak_FR*1.0]);
% ylim([0,1]);
ylim(yl);

hold on;
fill(t_sample_stim + [0 0 0.4 0.4], [0 100 100 0], [0.6 0.85 1], 'LineStyle', 'None');
plot([t_go t_go], [yl(1) yl(2)*1.8], 'k-','LineWidth',0.5);
plot([t_chirp1 t_chirp1], [yl(1) yl(2)*1.8], 'k-','LineWidth',0.5);
plot([t_chirp2 t_chirp2], [yl(1) yl(2)*1.8], 'k-','LineWidth',0.5);
if mod(plot_counter,columns2plot)==0
    %     ylabel(sprintf('%s\nNormalized\nResponse',ylab));
    text(xl(1)-diff(xl)*0.6, yl(1)+diff(yl)*0.5,sprintf('%s\nSpikes s^{-1}',ylab), 'FontSize',7,'HorizontalAlignment','center','Rotation',90);
    
    if flag_xlabel==1
        xlabel(sprintf('Time (s)\n'), 'FontSize',7,'HorizontalAlignment','center');
    end
end
shadedErrorBar(time2plot,L_clu.m,L_clu.stem,'lineprops',{'r-','markerfacecolor','r','linewidth',1});
shadedErrorBar(time2plot,R_clu.m,R_clu.stem,'lineprops',{'b-','markerfacecolor','b','linewidth',1},'transparent',1);


%     sum(cluster_percent(clusters_2plot))
set(gca,'xtick',[-4, -2, 0, 2],'ytick',[0 floor(yl(2))],'tickdir','out','ticklength',[.04 .04],'fontsize',7)

box off;