function fn_plotSelectivity (Param,time2plot, PSTH_L,PSTH_R,ylab, flag)


t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
t_presample_stim = Param.parameter_value{(strcmp('t_presample_stim',Param.parameter_name))};
t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
t_earlydelay_stim = Param.parameter_value{(strcmp('t_earlydelay_stim',Param.parameter_name))};
t_latedelay_stim = Param.parameter_value{(strcmp('t_latedelay_stim',Param.parameter_name))};

% PSTH_L = PSTH_L./peak_LR_hit_units;
% PSTH_R = PSTH_R./peak_LR_hit_units;


Selectivity = (PSTH_R - PSTH_L);

if strcmp(flag,'absolute')
    Selectivity = abs(Selectivity);
    Selectivity = Selectivity./nanmax(Selectivity,[],2);
    ylabel(sprintf('Normalized \n%s \n%s\n(Hz)',flag, ylab));
    S.m=nanmean(Selectivity,1);
    S.stem=nanstd(Selectivity,1)./sqrt(numel(Selectivity));
    y_max = round(100*nanmax([S.m+S.stem]))/100;
    y_min = min([0, round(100*nanmin([S.m+S.stem]))/100]);
    ylim([y_min,y_max]);
elseif strcmp(flag,'absolute not normalized')
    Selectivity = abs(Selectivity);
    ylabel(sprintf('Not normalized \nabsolute \n%s\n(Hz)',ylab));
    S.m=nanmean(Selectivity,1);
    S.stem=nanstd(Selectivity,1)./sqrt(numel(Selectivity));
    y_max = round(100*nanmax([S.m+S.stem]))/100;
    y_min = min([0, round(100*nanmin([S.m+S.stem]))/100]);
    ylim([y_min,y_max]);    
elseif strcmp(flag,'positive')
    Selectivity = Selectivity./nanmax(abs(Selectivity),[],2);
    Selectivity(Selectivity<=0) = NaN;
    ylabel(sprintf('Normalized \n%s \n%s\n(Hz)',flag, ylab));
    S.m=nanmean(Selectivity,1);
    S.stem=nanstd(Selectivity,1)./sqrt(numel(Selectivity));
    y_max = round(100*nanmax([S.m+S.stem]))/100;
     y_min = min([0, round(100*nanmin([S.m+S.stem]))/100]);
    ylim([y_min,y_max]);
elseif strcmp(flag,'negative')
    Selectivity = Selectivity./nanmax(abs(Selectivity),[],2);
    Selectivity(Selectivity>0) = NaN;
    ylabel(sprintf('Normalized \n%s \n%s\n(Hz)',flag, ylab));
    S.m=nanmean(Selectivity,1);
    S.stem=nanstd(Selectivity,1)./sqrt(numel(Selectivity));
    y_max = eps;
    y_min = round(100*nanmin([S.m+S.stem]))/100;
    ylim([y_min,0]);
elseif strcmp(flag,'')
    ylabel(sprintf('%s \n%s\n(Hz)',flag, ylab));
    S.m=nanmean(Selectivity,1);
    S.stem=nanstd(Selectivity,1)./sqrt(numel(Selectivity));
    y_max = round(100*nanmax([S.m+S.stem]))/100;
     y_min = min([0, round(100*nanmin([S.m+S.stem]))/100]);
    ylim([y_min,y_max]);
end



hold on;
plot([t_go t_go], [-100 100], 'k-','LineWidth',0.75);
plot([t_chirp1 t_chirp1], [-100 100], 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], [-100 100], 'k--','LineWidth',0.75);
xlabel(sprintf('Time (s)\n'));
shadedErrorBar(time2plot,S.m,S.stem,'lineprops',{'k-','markerfacecolor',[0.5 0.5 0.5],'linewidth',1});
xlim([-4.5, 1.5]);
% ylim([0,1]);

plot([-2.5,-2.5+0.4], [y_max,y_max],'-','linewidth',3,'color',[0 0 1],'Clipping','off');
set(gca,'xtick',[ -2, 0, 2],'ytick',[y_min y_max],'tickdir','out','ticklength',[.04 .04],'fontsize',12)
box off;