function fn_plot_regression_scatter(key_1D,key, TUNING, i_u, oneDnum, tnum, tuning_param_name, tuning_param_label, key_time_regression)
time_window_duration=0.2;
hold on;

key_time_dynamics=key;
key_time_dynamics.tuning_param_name=tuning_param_name{oneDnum};

key_unit.unit_uid=TUNING{tnum}.oneD{oneDnum}.unit_uid(i_u);
key_unit=fetch(EPHYS.Unit&key_unit);


rel_regression = ANL.RegressionTongueSingleUnit & key_time_dynamics & key_time_regression & (EPHYS.Unit &key_unit);

if strcmp(key.lick_direction,'left')
    key_lick_direction=EXP.TrialID & (ANL.LickDirectionTrial & key) & key_unit;
elseif strcmp(key.lick_direction,'right')
    key_lick_direction=EXP.TrialID & (ANL.LickDirectionTrial & key) & key_unit;
else
    key_lick_direction=EXP.TrialID & (ANL.Video1stLickTrial) & key_unit;
end


if key.flag_use_basic_trials==1
    rel_spikes=(ANL.TrialSpikesGoAligned &key_unit) & key_lick_direction    &  (EXP.BehaviorTrial&key_unit &  'early_lick="no early"') & (EXP.TrialName&key_unit & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1'));
else
    rel_spikes=(ANL.TrialSpikesGoAligned &key_unit) & key_lick_direction    &  (EXP.BehaviorTrial&key_unit &  'early_lick="no early"');
end

SPIKES=fetch(rel_spikes,'*','ORDER BY trial');
rel_video=((ANL.Video1stLickTrial & key_unit) & rel_spikes );
TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));

VariableNames=TONGUE.Properties.VariableNames';
var_table_offset=5;
VariableNames=VariableNames(var_table_offset:18);
idx_v_name=find(strcmp(VariableNames,tuning_param_name{oneDnum}));
labels=VariableNames{idx_v_name};

Y=TONGUE{:,idx_v_name+var_table_offset-1};

current_twnd(1)=key_time_regression.regression_time_start;
current_twnd(2)=key_time_regression.regression_time_start   + time_window_duration;

for i_tr=1:1:numel(SPIKES)
    
    spk_t=SPIKES(i_tr).spike_times_go;
    spk(i_tr)=sum(spk_t>current_twnd(1) & spk_t<current_twnd(2));%/diff(t_wnd);
end
FR_TRIAL=spk/time_window_duration;

%remove outliers
idx_outlier=isoutlier(Y);
Y(idx_outlier)=[];
FR_TRIAL(idx_outlier)=[];

Y=zscore(Y);



b1=fetchn(rel_regression,'regression_coeff_b1',  'ORDER BY regression_time_start');
b2=fetchn(rel_regression,'regression_coeff_b2',  'ORDER BY regression_time_start');

rsq_t=fetchn(rel_regression,'regression_rsq',  'ORDER BY regression_time_start');
p_t=fetchn(rel_regression,'regression_p',  'ORDER BY regression_time_start');

%plot scatter and regression

scatter(FR_TRIAL,Y,'.');
xl=[min(FR_TRIAL), max(FR_TRIAL)];
yCalc1 =  b1 + b2*xl;
plot(xl,yCalc1,'k-')

xlabel('FR (Hz)');
if oneDnum==1
ylabel(sprintf('t = %.1f \n %s', key_time_regression.regression_time_start,tuning_param_label{oneDnum}));
else
    ylabel(tuning_param_label(oneDnum));
end
title(sprintf('R^2=%.2f p=%.2f', rsq_t,p_t));
