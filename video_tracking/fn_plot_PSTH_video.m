function fn_plot_PSTH_video (TUNING, i_u, outcome)
Param = struct2table(fetch (ANL.Parameters,'*'));
t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
len = 0.4;
sz = [-100 100];

xdat = [0 0 len len];
ydat = [sz(1) sz(2) sz(2) sz(1)];


key_psth.outcome=outcome;
key_psth.unit_uid=TUNING{1}.oneD{1}.unit_uid(i_u);

hold on;
if strcmp(outcome,'hit')
title('Correct trials');
else
    title('Error trials');
end
hold on;
plot([t_go t_go], sz, 'k-','LineWidth',1.5);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
key_psth.trial_type_name='l';
p=fetch1(ANL.PSTHAverageLR & (EPHYS.Unit&key_psth) & key_psth,'psth_avg');
p=movmean(p,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
plot(time,p,'r');
peak(1)=nanmax(p);

key_psth.trial_type_name='r';
p=fetch1(ANL.PSTHAverageLR & (EPHYS.Unit&key_psth) & key_psth,'psth_avg');
p=movmean(p,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
plot(time,p,'b');
peak(2)=nanmax(p);
xlim([-4,2]);
ylim([0 nanmax(peak)]);
ylabel ('FR (Hz)','Fontsize', 8);
xlabel ('Time (s)','Fontsize', 8);
