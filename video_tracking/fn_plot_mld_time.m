function fn_plot_mld_time (TUNING, i_u, tnum, tuning_param_name, oneDnum, key)
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
key_time_dynamics.unit_uid=TUNING{tnum}.oneD{oneDnum}.unit_uid(i_u);
key_time_dynamics.tuning_param_name=tuning_param_name{oneDnum};

t=fetchn(ANL.UnitTongue1DTuningML*EPHYS.Unit & key_time_dynamics,'time_window_start',  'ORDER BY time_window_start');

tongue_ml_error_left=cell2mat(fetchn(ANL.UnitTongue1DTuningML*EPHYS.Unit & key_time_dynamics,'tongue_ml_error_left',  'ORDER BY time_window_start'));
tongue_ml_error_right=cell2mat(fetchn(ANL.UnitTongue1DTuningML*EPHYS.Unit & key_time_dynamics,'tongue_ml_error_right',  'ORDER BY time_window_start'));
if isempty(tongue_ml_error_left) ||  isempty(tongue_ml_error_right)
    return
end

tongue_ml_error_left=smooth(tongue_ml_error_left,3);
tongue_ml_error_right=smooth(tongue_ml_error_right,3);

plot([t_go t_go], sz, 'k-','LineWidth',0.75);
plot([t_chirp1 t_chirp1], sz, 'k--','LineWidth',0.75);
plot([t_chirp2 t_chirp2], sz, 'k--','LineWidth',0.75);
plot(t,tongue_ml_error_left,'-r')
plot(t,tongue_ml_error_right,'-b')
xlabel ('Time (s)','Fontsize', 8);
ylabel (sprintf('ML decoder \nerror'),'Fontsize', 8);
vname=replace(tuning_param_name{oneDnum},'_',' ');
vname=erase(vname,'lick');
% title(vname)
yl(1)=min([tongue_ml_error_left;tongue_ml_error_right]);
yl(2)=max([tongue_ml_error_left;tongue_ml_error_right]);

xlim([-4,2]);
ylim(yl);