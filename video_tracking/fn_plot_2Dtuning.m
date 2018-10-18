function fn_plot_2Dtuning (TUNING, i_u, tnum, time_window_start, twoDnum, flag_smooth_2D_display, tuning_param_label_2D)
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

hist_bins_x=TUNING{tnum}.twoD{twoDnum}.hist_bins_x(i_u,:);
hist_bins_y=TUNING{tnum}.twoD{twoDnum}.hist_bins_y(i_u,:);

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
if sum(~isnan(XY(:)))==0
    return
end
caxis([0 nanmax(XY(:))])
vname=replace(tuning_param_name_x,'_',' ');
vname=erase(vname,'lick');
xlabel(tuning_param_label_2D.x{twoDnum});
vname=replace(tuning_param_name_y,'_',' ');
vname=erase(vname,'lick');
ylabel(tuning_param_label_2D.y{twoDnum});
if twoDnum==2
    title(sprintf(' t = %.1f s \nr (odd,even)=%.1f ',time_window_start(tnum),stability));
else
    title(sprintf('r (odd,even)=%.1f ',stability));
end
xl=[hist_bins_x(1) , hist_bins_x(end)];
yl=[hist_bins_y(1) , hist_bins_y(end)];
%
% set(gca,'Xtick',[xl],'XLim',[yl]);
% set(gca,'Ytick',[ xl],'YLim',[yl]);
axis tight;
