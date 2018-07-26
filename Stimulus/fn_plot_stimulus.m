function  fn_plot_stimulus(rel, k)

% fetch Param
Param = struct2table(fetch (ANL.Parameters,'*'));
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth_stimulus',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);
t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
hold on
trial_types =unique(fetchn(rel,'trial_type_name'));
sz = [-200 200];
ydat = [sz(1) sz(2) sz(2) sz(1)];
for itype = 1:1:size(trial_types)
    kk.trial_type_name=trial_types{itype};
    stim_duration = fetch1(ANL.TrialTypeStimTime & kk, 'stim_duration');
    stim_onset = fetch1(ANL.TrialTypeStimTime & kk, 'stim_onset');
    for istim=1:1:numel(stim_onset)
        xdat = [0 0 stim_duration(istim) stim_duration(istim)];
        fill([stim_onset(istim) + xdat], ydat, [0.75 0.75 0.75], 'LineStyle', 'None');
    end
end
plot([t_go t_go], sz, 'k-','LineWidth',1.5);
plot([-5 5], [0 0], 'k-','LineWidth',0.75);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);


yl=0;
session_uid =unique(fetchn(rel,'session_uid'));

for itype = 1:1:size(trial_types)
    kk.trial_type_name=trial_types{itype};
    if kk.trial_type_name =='l'
        continue;
    end
    for i_s = 1:1:numel(session_uid)
        kk.trial_type_name=trial_types{itype};
        kk.session_uid = session_uid (i_s);
        trialtype_rgb = fetch1(ANL.TrialTypeGraphic & kk, 'trialtype_rgb');
        PSTH_Stim = movmean( cell2mat(fetchn((rel & k) & kk, 'psth_avg', 'ORDER BY unit_uid')),[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');
        
        kk.trial_type_name='l';
        PSTH_Baseline = movmean(cell2mat(fetchn((rel & k) & kk, 'psth_avg', 'ORDER BY unit_uid')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
        STIM_sess(i_s,:)=nanmean((PSTH_Stim-PSTH_Baseline),1);
    end
    STIM=nanmean(STIM_sess,1);
    plot(time,STIM,'Color',trialtype_rgb, 'LineWidth', 1.25);
    yl = [nanmin([STIM,yl]) nanmax([STIM,yl])];
end


xl=[-4 1];
xlim(xl);
ylim([floor(yl(1)),ceil(yl(2))]);
xlabel ('Time (s)','Fontsize', 10);
ylabel ('\Delta Firing rate (Hz)','Fontsize', 10);
set(gca,'FontSize',10);
text(-1.8,ceil(yl(2))*1.18,'Delay','FontSize',9);
