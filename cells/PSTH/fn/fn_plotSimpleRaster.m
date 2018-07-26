function fn_plotSimpleRaster(Param, Spikes, Session)
hold on;
trials=Spikes.trial;
trial_first = trials(1);
trial_last = trials(end);
spike_times_go= Spikes.spike_times_go; 
spike_times_go(cellfun(@isempty,Spikes.spike_times_go))={0};

hit = Spikes.trial (strcmp('hit',Spikes.outcome) & strcmp('no early',Spikes.early_lick))';
miss = Spikes.trial (strcmp('miss',Spikes.outcome) & strcmp('no early',Spikes.early_lick))';
ignore = Spikes.trial (strcmp('ignore',Spikes.outcome) & strcmp('no early',Spikes.early_lick))';
early = Spikes.trial (~strcmp('no early',Spikes.early_lick))';

for itr=miss
    ix=(trials==itr);
    plot(spike_times_go{ix,:}', itr,'.','Color',[1 0 0],'MarkerSize',0.5)
end

for itr=hit
    ix=(trials==itr);
    plot(spike_times_go{ix,:}', itr,'.','Color',[0 1 0],'MarkerSize',0.5)
end

for itr=early
    ix=(trials==itr);
    plot(spike_times_go{ix,:}', itr,'.','Color',[0 0 1],'MarkerSize',0.5)
end

for itr=ignore
    ix=(trials==itr);
    plot(spike_times_go{ix,:}', itr,'.','Color',[0 0 0],'MarkerSize',0.5)
end

plot([-5,5], [Spikes.trial(1),Spikes.trial(1)],'-k');
plot([-5,5], [Spikes.trial(end),Spikes.trial(end)],'-k');

ylabel ('# Trial','Fontsize', 8);
xlabel ('Time (s)','Fontsize', 8);
set(gca,'Fontsize', 8);

xlim([-4.5 2.5]);
ylim([0 size(Session,1)]);








