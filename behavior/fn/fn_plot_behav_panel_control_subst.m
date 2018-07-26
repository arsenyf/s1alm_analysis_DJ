function fn_plot_behav_panel_control_subst(behav_param, behav_param_mean, behav_param_signif, disp_offset, x_r, x_l, y_r, y_l, trn_r, trn_l, flag_plot_left_right_trials, plot_signif_offset,names_right_trials, names_left_trials )
hold on;
% inverse_r = 100 - behav_param_mean(trn_r(1));
% plot([0 6],[inverse_r inverse_r],'--b');
xlabel('Time (s)');
% ylabel(['\Delta ' sprintf('probability \nlick right  (%%)')]);
ylabel([sprintf('lick right \nbias (%%)')]);

set(gca, 'Xtick', [(-3.8+disp_offset),(-2.5+disp_offset), (-1.6+disp_offset), (-0.8+disp_offset),disp_offset], 'XtickLabel', {'-3.8','-2.5','-1.6', '-0.8','0',}, 'Ytick',[0 25 50], 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 0);
if (flag_plot_left_right_trials ==0 || flag_plot_left_right_trials ==2)
    counter=0;
    for i=2:1:numel(trn_r)
        counter =counter+1;
        values =  [behav_param(trn_r(i)).values] - [behav_param(trn_r(1)).mean];
        values_stem = nanstd(values)/sqrt(numel(values));
        errorbar_myown(x_r(counter),mean(values), values_stem, values_stem, 'b', 0.05)
        v_mean(counter) = nanmean(values);
        text(x_r(counter)-0.025,v_mean(counter)+plot_signif_offset,behav_param_signif(trn_r(i)),'HorizontalAlignment','Center','FontSize',16,'FontWeight','bold','Color',[0 0 1])
        yl=[-20 20];
    end
    plot(x_r,v_mean, '.-','MarkerSize',10,'Color',[0 0 1]);
end

if (flag_plot_left_right_trials ==0 || flag_plot_left_right_trials ==1)
    counter=0;
    for i=2:1:numel(trn_l)
        counter =counter+1;
        if exist('names_left_trials') && contains(names_left_trials(i),'r')
            values =  [behav_param(trn_l(i)).values] - (100-(nanmean([behav_param(trn_l(1)).values])));
            values_stem = nanstd(values)/sqrt(numel(values));
            errorbar_myown(x_l(counter),mean(values), values_stem, values_stem, 'r', 0.05)
            v_mean(counter) = nanmean(values);
            text(x_l(counter)+0.025,v_mean(counter)+plot_signif_offset,'***','HorizontalAlignment','Center','FontSize',16,'FontWeight','bold','Color',[1 0 0])
        yl=[0 50];
            
        else
            values = behav_param(trn_l(1)).mean - [behav_param(trn_l(i)).values];
            values_stem = nanstd(values)/sqrt(numel(values));
            errorbar_myown(x_l(counter),mean(values), values_stem, values_stem, 'r', 0.05)
            v_mean(counter) = nanmean(values);
            text(x_l(counter)+0.025,v_mean(counter)+plot_signif_offset,behav_param_signif(trn_l(i)),'HorizontalAlignment','Center','FontSize',16,'FontWeight','bold','Color',[1 0 0])
        yl=[0 50];
        end
    end
    plot(x_l,v_mean, '.-','MarkerSize',10,'Color',[1 0 0],'Clipping','off');
end

plot([-3+disp_offset -3+disp_offset],[-100 100],'--k');
plot([-2.15+disp_offset -2.15+disp_offset],[-100 100],'--k');
plot([0+disp_offset 0+disp_offset],[-100 100],'-k');

xlim([-4.3 0]);
ylim(yl);
set(gca,'YTick',yl);