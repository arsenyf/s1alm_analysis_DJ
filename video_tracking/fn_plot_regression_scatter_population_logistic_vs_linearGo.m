function fn_plot_regression_scatter_population_logistic_vs_linearGo(rel_P,  key, tuning_param_label)

hold on;


minimal_num_units_proj_trial=10;

Param = struct2table(fetch (ANL.Parameters,'*'));

time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};


rel_behav= EXP.TrialID & ((EXP.BehaviorTrial * EXP.SessionID * EXP.SessionTraining *ANL.SessionPosition * EXP.TrialName  * ANL.TrialTypeGraphic * ANL.Video1stLickTrialNormalized) & ANL.VideoTongueValidRTTrial & key  & 'early_lick="no early"'  & ANL.IncludeSession-ANL.ExcludeSession);

rel_behav=rel_behav & (ANL.RegressionDecodingSignificant& key);


rel_Proj = ((rel_P &key & rel_behav)  )*EXP.TrialID*EXP.TrialName;

rel_trials_Proj = EXP.TrialID & ((rel_P &key & rel_behav)  )*EXP.TrialName;
rel_trials_Proj=rel_trials_Proj.proj('trial_uid->trial_uid2');

rel_behav=rel_behav&rel_trials_Proj;


TONGUE = struct2table(fetch((ANL.Video1stLickTrialNormalized & rel_behav & key)*EXP.TrialID,'*' , 'ORDER BY trial_uid'));

idx_v1=~isoutlier(TONGUE.lick_rt_video_onset);
idx_v2=~isoutlier(table2array(TONGUE(:,key.tuning_param_name)));
idx_v = idx_v1 & idx_v2;

TONGUE=TONGUE(idx_v,:);


Y=table2array(TONGUE(:,key.tuning_param_name));
proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial_uid'));
time_idx_2plot = (time >=round(key.regression_time_start,4) & time<round(key.regression_time_start,4) + 0.2);
P.endpoint=nanmean(proj_trial(:,time_idx_2plot),2);

% 
% Y_outlier_idx= isoutlier(Y,'quartiles');
% 
% Y=Y(~Y_outlier_idx);

P.endpoint=P.endpoint(idx_v);

%% Exlude trials with too few neurons to project and outliers in terms of neural avtivity
% too few neurons
num_units_projected=fetchn(rel_Proj,'num_units_projected', 'ORDER BY trial_uid');
include_proj_idx=num_units_projected>minimal_num_units_proj_trial;
include_proj_idx=include_proj_idx(idx_v);
if sum(include_proj_idx)<=10
    return
end
%outliers in terms of neural activity
P_outlier_idx= isoutlier(P.endpoint,'quartiles');
%exluding
P.endpoint=(P.endpoint(~P_outlier_idx & include_proj_idx));
Y=Y(~P_outlier_idx & include_proj_idx,:);

%% computing regression coefficients
X=P.endpoint;
[X,Y,Linear, Logistic] = fn_compute_linear_and_logistic_regression (X,Y);

%% Plotting
xvec=min(X):0.01:max(X);
xl=([min(X) max(X)]);
yl=([0 max(Y)]);

hold on
plot(X,Y,'.k','MarkerSize',1); %data
plot(xvec,Linear.FittedCurve,'-b','LineWidth',2);
text(xl(1)+diff(xl)*0.1, yl(2)+diff(yl)*0.1, sprintf('R^2='),'Color',[0 0 0]);
text(xl(1)+diff(xl)*0.4, yl(2)+diff(yl)*0.1, sprintf('%.2f', Linear.R2),'Color',[0 0 1]);

if strcmp(key.lick_direction,'all')
    plot(xvec,Logistic.FittedCurve,'-m','LineWidth',2);
    text(xl(1)+diff(xl)*0.8, yl(2)+diff(yl)*0.1, sprintf('%.2f', Logistic.R2),'Color',[1 0 1]);
end

ylabel(sprintf(' %s',tuning_param_label'));
xlabel('Neural Proj (a.u.)');

xlim(xl);
ylim(yl);
