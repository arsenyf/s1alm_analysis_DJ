function maxval = fn_plot_PSTH_all_LvsR_trials (psth_cell, filt_mat, filt_mat2, ylegend, markertype, GP)

hold on;
len = 0.1;
sz = [0 100];

xdat = [0 0 len len];
ydat = [sz(1) sz(2) sz(2) sz(1)];

% fill(eps1tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
% fill(eps2tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
% fill(eps3tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
% fill(eps4tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');

plot([GP.cuetm GP.cuetm], sz, 'k-','LineWidth',2);
plot([GP.chirp1tm GP.chirp1tm], sz, 'k--','LineWidth',0.75);
plot([GP.chirp2tm GP.chirp2tm], sz, 'k--','LineWidth',0.75);
hold on
avg_psth (1,:) = nanmean ( psth_cell (:, logical(sum(filt_mat (:,GP.R_trials),2)) ),2);
avg_psth (2,:) = nanmean ( psth_cell (:, logical(sum(filt_mat (:,GP.L_trials),2)) ),2);
plot(GP.time,avg_psth (1,:), 'Color', [0 0 1], 'LineWidth', 2);
plot(GP.time,avg_psth (2,:), 'Color', [1 0 0], 'LineWidth', 2);
if ~isempty(filt_mat2)
    avg_psth (3,:) = nanmean ( psth_cell (:, logical(sum(filt_mat2 (:,GP.R_trials),2)) ),2);
    avg_psth (4,:) = nanmean ( psth_cell (:, logical(sum(filt_mat2 (:,GP.L_trials),2)) ),2);
    plot(GP.time,avg_psth (3,:), 'Color', [0 0.7 1], 'LineWidth', 1,'Marker',markertype,'MarkerSize',2.5);
    plot(GP.time,avg_psth (4,:), 'Color', [1 0.5 0.5], 'LineWidth', 1,'Marker',markertype,'MarkerSize',2.5);
end
maxval =nanmax(avg_psth(:));
plot([GP.samptm,GP.samptm+0.4], [maxval*1.1,maxval*1.1],'-','linewidth',5,'color',[0 0 1]);

xlabel ('Time (s)','Fontsize', 12);
ylabel (sprintf('%s\nFR (Hz)',ylegend),'Fontsize', 12);
set(gca,'Fontsize', 12);
xlim([GP.time(1) GP.time(end)]);
% ylim([0 maxval]);

% axis tight;
