function fn_plot_2Dtuning (TUNING, i_u, tnum, time_window_start, twoDnum, flag_smooth_2D_display)
p_threshold=0.05;
r_threshold=0.5;

hold on
XY=TUNING{tnum}.twoD{twoDnum}.tongue_tuning_2d{i_u,:};
remove_unoccupied_bins=zeros(size(XY));
remove_unoccupied_bins(isnan(XY)) =  +NaN;
XY(isnan(XY))=0;

if flag_smooth_2D_display==1
    % Smoothing = convolve with gaussian kernel:
    sigma = 0.5;
    XY = imgaussfilt(XY,sigma,'FilterDomain','spatial');
end
XY =  XY + remove_unoccupied_bins;


hist_bins_centers_x=TUNING{tnum}.twoD{twoDnum}.hist_bins_centers_x(i_u,:);
hist_bins_centers_y=TUNING{tnum}.twoD{twoDnum}.hist_bins_centers_y(i_u,:);

tuning_param_name_x=TUNING{tnum}.twoD{twoDnum}.tuning_param_name_x(i_u,:);
tuning_param_name_y=TUNING{tnum}.twoD{twoDnum}.tuning_param_name_y(i_u,:);

stability=TUNING{tnum}.twoD{twoDnum}.stability_odd_even_corr_r(i_u,:);
SI=TUNING{tnum}.twoD{twoDnum}.tongue_tuning_2d_si(i_u,:);
pvalue=NaN;%TUNING{num}.XY.pvalue_si_2d(i_u,:);
imagescnan(hist_bins_centers_x,hist_bins_centers_y,XY')
set(gca,'YDir','normal')
hold on
colormap(jet);
colorbar;
caxis([0 nanmax(XY(:))])
vname=replace(tuning_param_name_x,'_',' ');
vname=erase(vname,'lick');
    xlabel(vname);
vname=replace(tuning_param_name_y,'_',' ');
vname=erase(vname,'lick');
ylabel(vname);
if twoDnum==2
title(sprintf(' t = %.1f s \nr (odd,even)=%.1f ',time_window_start(tnum),stability));
else
    title(sprintf('r (odd,even)=%.1f ',stability));
end
set(gca,'Xtick',[ 0 1],'XLim',[ 0 1]);
set(gca,'Ytick',[ 0 1],'YLim',[ 0 1]);

