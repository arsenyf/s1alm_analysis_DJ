function fn_plot_stability_time (TUNING, i_u, tnum, tuning_param_name, xnoneDnumum, key)
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
sz = [-1 1];

xdat = [0 0 len len];
ydat = [sz(1) sz(2) sz(2) sz(1)];




hold on;

key_time_dynamics=key;
key_time_dynamics.unit_uid=TUNING{tnum}.oneD{xnoneDnumum}.unit_uid(i_u);
key_time_dynamics.tuning_param_name=tuning_param_name{xnoneDnumum};

t=fetchn(ANL.UnitTongue1DTuning*EPHYS.Unit & key_time_dynamics,'time_window_start',  'ORDER BY time_window_start');

if strcmp(key.lick_direction,'all')
    rel_tuning = ANL.UnitTongue1DTuning;
elseif strcmp(key.lick_direction,'left')
    rel_tuning = ANL.UnitTongue1DTuningLRseparate& key_time_dynamics;
elseif strcmp(key.lick_direction,'right')
    rel_tuning = ANL.UnitTongue1DTuningLRseparate& key_time_dynamics;
end


r_t=fetchn(rel_tuning&(EPHYS.Unit & key_time_dynamics),'stability_odd_even_corr_r',  'ORDER BY time_window_start');
% r_t=smooth(r_t,3);

plot([t_go t_go], sz, 'k-','LineWidth',0.75);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
plot([-5 5], [0.5 0.5], 'g-','LineWidth',0.5);

plot(t,r_t,'-')
% xlabel ('Time (s)','Fontsize', 8);
ylabel (sprintf('corr \n(odd,even)'),'Fontsize', 8);
vname=replace(tuning_param_name{xnoneDnumum},'_',' ');
vname=erase(vname,'lick');
% title(vname)
xlim([-4,2]);
ylim([-1 1]);