function  fn_plot_PSTH_basic_trials (Unit,PSTH, Param, outcome)

hold on;
len = 0.1;
sz = [0 200];

xdat = [0 0 len len];
ydat = [sz(1) sz(2) sz(2) sz(1)];

% fill(eps1tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
% fill(eps2tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
% fill(eps3tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');
% fill(eps4tm+xdat, ydat, [0 0 0], 'FaceAlpha', 0.12, 'LineStyle', 'None');

t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
mintrials_psth_typeoutcome= Param.parameter_value{(strcmp('mintrials_psth_typeoutcome',Param.parameter_name))};

idx_few_trials = find(PSTH.num_trials_averaged <mintrials_psth_typeoutcome);

plot([t_go t_go], sz, 'k-','LineWidth',2);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);

p(1).idx = find((strcmp('r',PSTH.trial_type_name)) & (strcmp('hit',PSTH.outcome)));
p(2).idx = find((strcmp('l',PSTH.trial_type_name)) & (strcmp('hit',PSTH.outcome)));

p(1).psth=smooth(PSTH.psth_avg(p(1).idx,:),smooth_bins);
p(2).psth=smooth(PSTH.psth_avg(p(2).idx,:),smooth_bins);
plot(time,p(1).psth, 'Color', [0 0 1], 'LineWidth', 2);
plot(time,p(2).psth, 'Color', [1 0 0], 'LineWidth', 2);
ylabel (sprintf('\nFR (Hz)'),'Fontsize', 12);


if ~isempty(outcome)
    p(3).idx = find((strcmp('r',PSTH.trial_type_name)) & (strcmp(outcome,PSTH.outcome)));
    p(4).idx = find((strcmp('l',PSTH.trial_type_name)) & (strcmp(outcome,PSTH.outcome)));
    p(3).psth=smooth(PSTH.psth_avg(p(3).idx,:),smooth_bins);
    p(4).psth=smooth(PSTH.psth_avg(p(4).idx,:),smooth_bins);
    
    blank=zeros(1,4);
    blank(ismember([p.idx],idx_few_trials))=NaN;
    p(3).psth=smooth(PSTH.psth_avg(p(3).idx,:),smooth_bins) + blank(3);
    p(4).psth=smooth(PSTH.psth_avg(p(4).idx,:),smooth_bins) + blank(4);
    plot(time,p(3).psth, 'Color', [0 0.7 1], 'LineWidth', 1,'Marker','x','MarkerSize',2.5);
    plot(time,p(4).psth, 'Color', [1 0.5 0.5], 'LineWidth', 1,'Marker','x','MarkerSize',2.5);
    title(sprintf('hit vs. %s trials',outcome),'Fontsize', 12);
else
    title('hit trials','Fontsize', 12);
end

ylabel ('FR (Hz)','Fontsize', 12);
xlabel ('Time (s)','Fontsize', 12);
set(gca,'Fontsize', 12);
xlim([-4.5 2.5]);
ylim([0 Unit.peak_fr]);

% axis tight;