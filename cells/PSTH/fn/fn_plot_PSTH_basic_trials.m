function  fn_plot_PSTH_basic_trials (Unit,PSTH, Param, outcome)

hold on;
len = 0.4;
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
t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
mintrials_psth_typeoutcome= Param.parameter_value{(strcmp('mintrials_psth_typeoutcome',Param.parameter_name))};

idx_few_trials = find(PSTH.num_trials_averaged <mintrials_psth_typeoutcome);


fill([t_sample_stim + xdat], ydat, [0.75 0.75 0.75], 'LineStyle', 'None');
plot([t_sample_stim t_sample_stim+0.4],[Unit.peak_fr Unit.peak_fr], 'Color', [0 0 1], 'LineWidth', 4);
plot([t_go t_go], sz, 'k-','LineWidth',1.5);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);

% p(1).idx = find((strcmp('r',PSTH.trial_type_name)) & (strcmp(outcome,PSTH.outcome)));
% p(2).idx = find((strcmp('l',PSTH.trial_type_name)) & (strcmp(outcome,PSTH.outcome)));
%
% p(1).psth=smooth(PSTH.psth_avg(p(1).idx,:),smooth_bins);
% p(2).psth=smooth(PSTH.psth_avg(p(2).idx,:),smooth_bins);
% plot(time,p(1).psth, 'Color', [0 0 1], 'LineWidth', 1);
% plot(time,p(2).psth+0.2, 'Color', [1 0 0], 'LineWidth', 1);
% ylabel (sprintf('\nFR (Hz)'),'Fontsize', 12);

if strcmp(outcome,'hit')
    p(1).color= [0 0 1];
    p(2).color= [1 0 0];
else % for ignore or error trials
    p(1).color= [0.3906    0.5820    0.9258];
    p(2).color= [1    0.5000    0.4453];
end
p(1).idx = find((strcmp('r',PSTH.trial_type_name)) & (strcmp(outcome,PSTH.outcome)));
p(2).idx = find((strcmp('l',PSTH.trial_type_name)) & (strcmp(outcome,PSTH.outcome)));





blank=zeros(1,2);
blank(ismember([p.idx],idx_few_trials))=NaN;
p(1).psth=  movmean(PSTH.psth_avg(p(1).idx,:),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink') + blank(1);
p(2).psth=  movmean(PSTH.psth_avg(p(2).idx,:),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink') + blank(2);
plot(time,p(1).psth, 'Color', p(1).color , 'LineWidth', 0.7);
plot(time,p(2).psth+0.2, 'Color', p(2).color, 'LineWidth', 0.7);
title(sprintf('%s trials\n',outcome),'Fontsize', 12);



ylabel ('FR (Hz)','Fontsize', 12);
xlabel ('Time (s)','Fontsize', 12);
set(gca,'Fontsize', 12);
xlim([-4.5 2.5]);
ylim([0 Unit.peak_fr]);

% axis tight;