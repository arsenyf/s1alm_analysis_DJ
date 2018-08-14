function  fn_plot_stimulus_quantification(rel, k,colr, plot_r_flag)

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

counter=1;

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
        PSTH_Stim = movmean(cell2mat(fetchn((rel & k) & kk, 'psth_avg', 'ORDER BY unit_uid')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
        stim_duration = fetch1(ANL.TrialTypeStimTime & kk, 'stim_duration');
        stim_onset = fetch1(ANL.TrialTypeStimTime & kk, 'stim_onset');
        
        kk.trial_type_name='l';
        PSTH_Baseline = movmean(cell2mat(fetchn((rel & k) & kk, 'psth_avg', 'ORDER BY unit_uid')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
        %         STIM=nanmean((PSTH_Stim-PSTH_Baseline),1);
        STIM=(PSTH_Stim-PSTH_Baseline);
        t_idx = (time>=stim_onset & time<stim_onset+stim_duration+0.1);
        %         delta_spikes(i_s,counter) = max(STIM(t_idx))/stim_duration;
        delta_spikes(i_s,counter) = nanmean((nansum(STIM(:,t_idx),2)./sum(t_idx))*stim_duration);
        %         delta_spikes(:,counter) = nanmax(STIM(:,t_idx),2)/stim_duration;
    end
    stim_onset_vector (counter) = stim_onset;
    counter = counter+1;
    
end

% end


[~,onset_order]=sort(stim_onset_vector);

delta_spikes = delta_spikes(:,onset_order);
stim_onset_vector = stim_onset_vector(onset_order);
ds_mean = nanmean(delta_spikes,1);
ds_stem = nanstd(delta_spikes,1)./sqrt(size(delta_spikes,1));

hold on
plot(stim_onset_vector, ds_mean,'.-','linewidth',2,'Color', colr);
errorbar(stim_onset_vector, ds_mean, ds_stem, '-', 'Color',colr,'CapSize',4,'MarkerSize',6);

plot([t_go t_go], sz, 'k--','LineWidth',0.75);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);

if numel(stim_onset_vector) ==3
    t = table( delta_spikes(:,1),delta_spikes(:,2),delta_spikes(:,3),...
        'VariableNames',{'meas1','meas2','meas3'});
    Time = stim_onset_vector';
    rm = fitrm(t,'meas1-meas3 ~ 1','WithinDesign',Time);
else numel(stim_onset_vector) ==4
    t = table( delta_spikes(:,1),delta_spikes(:,2),delta_spikes(:,3),delta_spikes(:,4),...
        'VariableNames',{'meas1','meas2','meas3','meas4'});
    Time = stim_onset_vector';
    rm = fitrm(t,'meas1-meas4 ~ 1','WithinDesign',Time);
end
ranovatbl = ranova(rm);
ranovatbl.pValue
if ranovatbl.pValue(1)<=0.05
    tbl = multcompare(rm,'Time','ComparisonType','bonferroni')
end

