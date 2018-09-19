function [yl]=fn_plot_si_time (TUNING, i_u, tnum, tuning_param_name, oneDnum, key, flag_per_spike_or_per_sec)

%flag_per_spike_or_per_sec 1  information per spike
%flag_per_spike_or_per_sec 2  information per second

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
sz = [0 200];

xdat = [0 0 len len];
ydat = [sz(1) sz(2) sz(2) sz(1)];




hold on;

key_time_dynamics=key;
key_time_dynamics.unit_uid=TUNING{tnum}.oneD{oneDnum}.unit_uid(i_u);
key_time_dynamics.tuning_param_name=tuning_param_name{oneDnum};

vname=replace(tuning_param_name{oneDnum},'_',' ');
vname=erase(vname,'lick');

t=fetchn(ANL.UnitTongue1DTuning*EPHYS.Unit & key_time_dynamics,'time_window_start',  'ORDER BY time_window_start');


if strcmp(key.lick_direction,'all')
    rel_tuning = ANL.UnitTongue1DTuning;
    rel_shuffling = ANL.UnitTongue1DTuningShuffling;
elseif strcmp(key.lick_direction,'left')
    rel_tuning = ANL.UnitTongue1DTuningLRseparate;
    rel_shuffling = ANL.UnitTongue1DTuningLRseparateShuffling;
elseif strcmp(key.lick_direction,'right')
    rel_tuning = ANL.UnitTongue1DTuningLRseparate;
    rel_shuffling = ANL.UnitTongue1DTuningLRseparateShuffling;
end

si_t=fetchn(rel_tuning*EPHYS.Unit & key_time_dynamics,'tongue_tuning_1d_si',  'ORDER BY time_window_start');
% si_t_shuffled_mean=fetchn(rel_shuffling*EPHYS.Unit & key_time_dynamics,'tongue_tuning_1d_si_shuffled_mean',  'ORDER BY time_window_start');
si_t_shuffled=fetchn(rel_shuffling*EPHYS.Unit & key_time_dynamics,'tongue_tuning_1d_si_shuffled',  'ORDER BY time_window_start');

for i_t =1:1:numel(si_t_shuffled)
    shuffled_95_prctile(i_t,1)=prctile(si_t_shuffled{i_t},95);
end

if flag_per_spike_or_per_sec==2
    mean_fr_window=fetchn(rel_tuning*EPHYS.Unit & key_time_dynamics,'mean_fr_window',  'ORDER BY time_window_start');
    si_t=si_t.*mean_fr_window;
%     si_t_shuffled=si_t_shuffled.*mean_fr_window;
    shuffled_95_prctile=(shuffled_95_prctile.*mean_fr_window);
    ylabel (sprintf('Information \n(bits/sec)'),'Fontsize', 8);
    title(vname)
    %     xlabel ('Time (s)','Fontsize', 8);
else
    ylabel (sprintf('Information \n(bits/spike)'),'Fontsize', 8);
end
% si_t=smooth(si_t,3);
% shuffled_95_prctile=smooth(shuffled_95_prctile,3);

plot([t_go t_go], sz, 'k-','LineWidth',0.75);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
plot(t,shuffled_95_prctile,'-','Color',[0 1 0],'LineWidth',0.5)
plot(t,si_t,'-','Color',[0 0 0],'LineWidth',1)
xlim([-4,2]);
yl=[0 nanmax([si_t;shuffled_95_prctile])+eps];
ylim(yl);