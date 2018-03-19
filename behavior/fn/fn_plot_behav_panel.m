function fn_plot_behav_panel(behav_param,behav_param_mean, behav_param_signif, disp_offset, x_r, x_l, y_r, y_l, trn_r, trn_l )
hold on;
inverse_r = 100 - behav_param_mean(trn_r(1));
plot([0 6],[inverse_r inverse_r],'--b');
xlabel('Time (s)');
ylabel('Performance (%)');
set(gca, 'Xtick', [1, (-3.8+disp_offset),(-2.5+disp_offset), (-1.6+disp_offset), (-0.8+disp_offset)], 'XtickLabel', {'Control', '-3.8','-2.5','-1.6', '-0.8'}, 'Ytick',[0,25,50,75,100], 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 0);
for i=1:1:numel(trn_r)
    values = [behav_param(trn_r(i)).values];
    for  iv=1:1:numel(values)
    plot(x_r(i)-0.025-rand(1)/10,values(iv), '.','MarkerSize',5,'Color',[0.75 0.75 1]);
    end
end

for i=1:1:numel(trn_l)
    values = [behav_param(trn_l(i)).values];
    for  iv=1:1:numel(values)
        plot(x_l(i)+0.025+rand(1)/10,values(iv), '.','MarkerSize',5,'Color',[1 0.75 0.75]);
    end
end

plot(x_r(1)-0.025, y_r(1), 'o-b','MarkerSize',5,'LineWidth',2);
plot(x_l(1)+0.025, y_l(1), 'o-r','MarkerSize',5,'LineWidth',2);
plot(x_r(2:end)-0.025, y_r(2:end), 'o--b','MarkerSize',5,'LineWidth',2);
plot(x_l(2:end)+0.025, y_l(2:end), 'o--r','MarkerSize',5,'LineWidth',2);
plot([-3+disp_offset -3+disp_offset],[0 100],'-k');
plot([-2.15+disp_offset -2.15+disp_offset],[0 100],'-k');


for i=1:1:numel(trn_r)
    text(x_r(i)-0.025,y_r(i)+5,behav_param_signif(trn_r(i)),'HorizontalAlignment','Center','FontSize',14,'FontWeight','bold','Color',[0 0 1])
end

for i=1:1:numel(trn_l)
    text(x_l(i)+0.025,y_l(i)-10,behav_param_signif(trn_l(i)),'HorizontalAlignment','Center','FontSize',14,'FontWeight','bold','Color',[1 0 0])
end
xlim([0.5 5.5]);

