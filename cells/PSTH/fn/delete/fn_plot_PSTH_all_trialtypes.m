function maxval = fn_plot_PSTH_all_trialtypes (psth_cell, filt_mat, order, GP)

hold on;
len = 0.1;
sz = [0 100];

xdat = [0 0 len len];
ydat = [sz(1) sz(2) sz(2) sz(1)];

fill(GP.eps1tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
fill(GP.eps2tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
fill(GP.eps3tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
fill(GP.eps4tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');

plot([GP.cuetm GP.cuetm], sz, 'k-','LineWidth',2);
plot([GP.chirp1tm GP.chirp1tm], sz, 'k--','LineWidth',0.75);
plot([GP.chirp2tm GP.chirp2tm], sz, 'k--','LineWidth',0.75);

for j = order
    avg_psth (j,:) = nanmean ( psth_cell (:, filt_mat (:,j)),2);
    hold on;
    plot(GP.time,avg_psth (j,:), 'Color', trialCol(j, GP), 'LineWidth', 1.5);
end;

maxval =nanmax(avg_psth(:));

xlabel ('Time (s)','Fontsize', 12);
ylabel ('FR (Hz)','Fontsize', 12);
set(gca,'Fontsize', 12);
xlim([GP.time(1) GP.time(end)]);
% axis tight;
