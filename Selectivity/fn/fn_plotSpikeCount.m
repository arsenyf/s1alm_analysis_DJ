function fn_plotSpikeCount (Param, time, PSTH_L, PSTH_R,ylab,flag)
idx2plot= (time>=-4.5 & time<1.5);
time = time(idx2plot);


PSTH_L = PSTH_L (:,idx2plot);
PSTH_R = PSTH_R (:,idx2plot);

if contains(flag,'Normalized')
peak_LR_hit_units = nanmax([PSTH_L,PSTH_R],[],2);
PSTH_L = PSTH_L./peak_LR_hit_units;
PSTH_R = PSTH_R./peak_LR_hit_units;
end

t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
t_presample_stim = Param.parameter_value{(strcmp('t_presample_stim',Param.parameter_name))};
t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
t_earlydelay_stim = Param.parameter_value{(strcmp('t_earlydelay_stim',Param.parameter_name))};
t_latedelay_stim = Param.parameter_value{(strcmp('t_latedelay_stim',Param.parameter_name))};

% PSTH_L = PSTH_L./peak_LR_hit_units;
% PSTH_R = PSTH_R./peak_LR_hit_units;

L_clu.m=nanmean(PSTH_L,1);
L_clu.stem=nanstd(PSTH_L,1)./sqrt(size(PSTH_L,1));
R_clu.m=nanmean(PSTH_R,1);
R_clu.stem=nanstd(PSTH_R,1)./sqrt(size(PSTH_R,1));

y_max = round(100*nanmax([L_clu.m+L_clu.stem,R_clu.m+R_clu.stem]))/100;
y_min = round(100*nanmin([L_clu.m+L_clu.stem,R_clu.m+R_clu.stem]))/100;

hold on;
plot([t_go t_go], [-100 100], 'k-','LineWidth',0.75);
plot([t_chirp1 t_chirp1], [-100 100], 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], [-100 100], 'k--','LineWidth',0.75);
ylabel(sprintf('%s\n Firing Rate\n(Hz)',flag));
xlabel(sprintf('Time (s)\n'));
shadedErrorBar(time,L_clu.m,L_clu.stem,'lineprops',{'r-','markerfacecolor','r','linewidth',1});
shadedErrorBar(time,R_clu.m,R_clu.stem,'lineprops',{'b-','markerfacecolor','b','linewidth',1},'transparent',1);
xlim([-4.5, 1.5]);
% ylim([0,1]);
plot([-2.5,-2.5+0.4], [y_max,y_max],'-','linewidth',3,'color',[0 0 1],'Clipping','off');
%     sum(cluster_percent(clusters_2plot))
set(gca,'xtick',[ -2, 0, 2],'ytick',[y_min y_max],'tickdir','out','ticklength',[.04 .04],'fontsize',12)
ylim([y_min,y_max]);

box off;