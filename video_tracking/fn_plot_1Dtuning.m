function fn_plot_1Dtuning (TUNING, i_u, tnum, tuning_param_name, time_window_start, xnum,flag_smooth_1D_display,key)
p_threshold=0.05;
r_threshold=0.5;
hist_bins_centers=TUNING{tnum}.oneD{xnum}.hist_bins_centers(i_u,:);

hold on
X=TUNING{tnum}.oneD{xnum}.tongue_tuning_1d(i_u,:);
if flag_smooth_1D_display==1
    X=smooth(X,3);
end

stability=TUNING{tnum}.oneD{xnum}.stability_odd_even_corr_r(i_u,:);
SI=TUNING{tnum}.oneD{xnum}.tongue_tuning_1d_si(i_u,:);
pvalue=TUNING{tnum}.oneD{xnum}.pvalue_si_1d(i_u,:);
plot(hist_bins_centers,X);
ylim([0,nanmax([X,eps])+eps]);
vname=replace(tuning_param_name{xnum},'_',' ');
vname=erase(vname,'lick');
xlabel(vname);

if strcmp(key.lick_direction,'left')
    xl=[0,0.5];
elseif strcmp(key.lick_direction,'right')
    xl=[0.5,1];
elseif strcmp(key.lick_direction,'all')
    xl=[0,1];
end


if tnum==1
    if pvalue<=p_threshold
        %         text(-0.25,nanmax(X)*1.5,sprintf('p= %.2f', pvalue),'FontSize',8,'Color',[0 1 0]);
        text(-diff(xl)/4,nanmax(X)*1.3,sprintf('I = %.2f', SI),'FontSize',8,'Color',[0 1 0]);
    else
        %         text(-0.25,nanmax(X)*1.5,sprintf('p= %.2f', pvalue),'FontSize',8);
        text(-diff(xl)/4,nanmax(X)*1.3,sprintf('I = %.2f', SI),'FontSize',8);
    end
    
    if stability>=r_threshold
        text(-diff(xl)/4,nanmax(X)*1.1,sprintf('r = %.2f', stability),'FontSize',8,'Color',[0 1 0]);
    else
        text(-diff(xl)/4,nanmax(X)*1.1,sprintf('r = %.2f', stability),'FontSize',8);
    end
    ylabel(sprintf(' t = %.1f s \n FR (Hz)',time_window_start(tnum)),'FontSize',8);
    
else
    if pvalue<=p_threshold
        text(diff(xl)/2,nanmax(X)*1.3,sprintf('I = %.2f', SI),'FontSize',8,'Color',[0 1 0]);
        %         text(0.5,nanmax(X)*1.5,sprintf('p= %.2f', pvalue),'FontSize',8,'Color',[0 1 0]);
    else
        text(diff(xl)/2,nanmax(X)*1.3,sprintf('I = %.2f', SI),'FontSize',8);
        %         text(0.5,nanmax(X)*1.5,sprintf('p= %.2f', pvalue),'FontSize',8);
    end
    
    if stability>=r_threshold
        text(diff(xl)/2,nanmax(X)*1.1,sprintf('r = %.2f', stability),'FontSize',8,'Color',[0 1 0]);
    else
        text(diff(xl)/2,nanmax(X)*1.1,sprintf('r = %.2f', stability),'FontSize',8);
    end
    ylabel(sprintf(' t = %.1f s',time_window_start(tnum)),'FontSize',8);
end
xlim(xl);