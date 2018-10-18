function fn_plot_1DtuningReconstruction (TUNING,TUNING_RECON, i_u, tnum, tuning_param_name,reconstruction_tuning_param_name, time_window_start, xnum,recNum, flag_smooth_1D_display,key, tuning_param_label)
p_threshold=0.05;
r_threshold=0.5;
hist_bins_centers=TUNING_RECON{tnum}.oneD{xnum}.reconstructBy{recNum}.hist_bins_centers(i_u,:);
hist_bins=TUNING{tnum}.oneD{xnum}.hist_bins(i_u,:);

hold on
X=TUNING_RECON{tnum}.oneD{xnum}.reconstructBy{recNum}.tongue_tuning_1d_reconstructed(i_u,:);
if flag_smooth_1D_display==1
    X=smooth(X,3);
end

SI=TUNING_RECON{tnum}.oneD{xnum}.reconstructBy{recNum}.si_reconstructed(i_u,:);
reconstruction_error=TUNING_RECON{tnum}.oneD{xnum}.reconstructBy{recNum}.reconstruction_error(i_u,:);
plot(hist_bins_centers,X,'.-');
ylim([0,nanmax([X,eps])+eps]);
vname1=replace(tuning_param_label{xnum},'_',' ');
vname1=erase(vname1,'lick');
vname2=replace(tuning_param_label{recNum},'_',' ');
vname2=erase(vname2,'lick');
xlabel(sprintf('%s by \n %s', vname1,vname2));

xl=[hist_bins(1),hist_bins(end)];

% if strcmp(key.lick_direction,'left')
%     xl=[floor(10*min(hist_bins_centers))/10 , ceil(10*max(hist_bins_centers))/10];
% elseif strcmp(key.lick_direction,'right')
%     xl=[floor(10*min(hist_bins_centers))/10 , ceil(10*max(hist_bins_centers))/10];
% elseif strcmp(key.lick_direction,'all')
%     xl=[floor(10*min(hist_bins_centers))/10 , ceil(10*max(hist_bins_centers))/10];
% end



if tnum==1
    text(xl(1)-diff(xl)/4,nanmax(X)*1.3,sprintf('I = %.2f', SI),'FontSize',8,'Color',[0 0 0]);
    text(xl(1)-diff(xl)/4,nanmax(X)*1.1,sprintf('Er = %.1f', reconstruction_error),'FontSize',8,'Color',[0 0 0]);
    if xnum==1
        ylabel(sprintf(' t = %.1f s \n FR (Hz)',time_window_start(tnum)),'FontSize',8);
    end
else
    text(xl(1)+diff(xl)/2,nanmax(X)*1.3,sprintf('I = %.2f', SI),'FontSize',8,'Color',[0 0 0]);
    text(xl(1)+diff(xl)/2,nanmax(X)*1.1,sprintf('Er = %.1f', reconstruction_error),'FontSize',8,'Color',[0 0 0]);
    if xnum==1
        
        ylabel(sprintf(' t = %.1f s',time_window_start(tnum)),'FontSize',8);
    end
end
xlim(xl);