function  fn_plot_svm_performance(svm_performance,t,legend_flag)

hold on;
Param = struct2table(fetch (ANL.Parameters,'*'));

t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
t_presample_stim = Param.parameter_value{(strcmp('t_presample_stim',Param.parameter_name))};
t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
t_earlydelay_stim = Param.parameter_value{(strcmp('t_earlydelay_stim',Param.parameter_name))};
t_latedelay_stim = Param.parameter_value{(strcmp('t_latedelay_stim',Param.parameter_name))};

plot([t_go t_go], [0 100], 'k-','LineWidth',0.75);
plot([t_chirp1 t_chirp1], [0 100], 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], [0 100], 'k--','LineWidth',0.75);

num=3;
if ~isempty(svm_performance(num).all)
    shadedErrorBar(t,svm_performance(num).m,svm_performance(num).stem,'lineprops',{'k-','markerfacecolor','k','linewidth',1});
end
num=2;
if ~isempty(svm_performance(num).all)
    shadedErrorBar(t,svm_performance(num).m,svm_performance(num).stem,'lineprops',{'b-','markerfacecolor','b','linewidth',1});
end
num=1;
if ~isempty(svm_performance(num).all)
    shadedErrorBar(t,svm_performance(num).m,svm_performance(num).stem,'lineprops',{'m-','markerfacecolor','m','linewidth',1});
end
ylim([48 100]);
xlim([t(1) 0.65]);
if legend_flag==1
        text(1,100,'vS1 left','FontSize',8,'FontWeight','bold','Color',[0.5 0.5 0.5]);
    text(1,90,'ALM left','FontSize',8,'FontWeight','bold','Color',[1 0 1]);
    text(1,80,'ALM right','FontSize',8,'FontWeight','bold','Color',[0 0 0.8]);
end
plot([-2.5,-2.5+0.4], [100,100],'-','linewidth',3,'color',[0 0 1],'Clipping','off');

xlabel('Time (s)','FontSize',12);
ylabel('Decoder perform. (%)','FontSize',12);
set(gca,'YTick',[50, 75, 100],'FontSize',12);
box off;