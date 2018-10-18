function fn_plot_regression_scatter_population(rel,rel_P,  key, tuning_param_label)

hold on;


minimal_num_units_proj_trial=5;

Param = struct2table(fetch (ANL.Parameters,'*'));

time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};


rel_behav= EXP.TrialID & ((EXP.BehaviorTrial * EXP.SessionID * EXP.SessionTraining *ANL.SessionPosition * EXP.TrialName  * ANL.TrialTypeGraphic * ANL.Video1stLickTrialZscoreAllLR) & key  & 'early_lick="no early"'  & ANL.IncludeSession-ANL.ExcludeSession);

rel_Proj = ((rel_P &key & rel_behav)  )*EXP.TrialID*EXP.TrialName;

rel_trials_Proj = EXP.TrialID & ((rel_P &key & rel_behav)  )*EXP.TrialName;
rel_trials_Proj=rel_trials_Proj.proj('trial_uid->trial_uid2');

rel_behav=rel_behav&rel_trials_Proj;


TONGUE = struct2table(fetch((ANL.Video1stLickTrialZscoreAllLR & rel_behav & key)*EXP.TrialID,'*' , 'ORDER BY trial_uid'));

Y=table2array(TONGUE(:,key.tuning_param_name));
proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial_uid'));
time_idx_2plot = (time >=round(key.regression_time_start,4) & time<round(key.regression_time_start,4) + 0.5);
P.endpoint=nanmean(proj_trial(:,time_idx_2plot),2);


Y_outlier_idx= isoutlier(Y,'quartiles');

Y=Y(~Y_outlier_idx);

P.endpoint=P.endpoint(~Y_outlier_idx);


%exlude trials with too few neurons to project
num_units_projected=fetchn(rel_Proj,'num_units_projected', 'ORDER BY trial_uid');
include_proj_idx=num_units_projected>minimal_num_units_proj_trial;

include_proj_idx=include_proj_idx(~Y_outlier_idx);

if sum(include_proj_idx)<=10
    return
end
%exlude outliers
P_outlier_idx= isoutlier(P.endpoint,'quartiles');

P.endpoint=(P.endpoint(~P_outlier_idx & include_proj_idx));
Y=Y(~P_outlier_idx & include_proj_idx,:);

Predictor = [ones(size(P.endpoint,1),1) P.endpoint];
[beta,~,~,~,stats]= regress(Y,Predictor);
Rsq = stats(1);  %stats [Rsq, F-statistic, p-value, and an estimate of the error variance.]
regression_p=stats(3);
yCalc1 =  beta(1) + beta(2)*P.endpoint;

rmse_regression = sqrt(mean((Y - yCalc1).^2));  % Root Mean Squared Error
rmse_mean = sqrt(mean((Y - mean(Y)).^2));  % Root Mean Squared Error

plot(P.endpoint,Y,'.','MarkerSize',2);
xl=[min(P.endpoint) max(P.endpoint)];


yCalc1 =  beta(1) + beta(2)*xl;
plot(xl,yCalc1,'k-')
title(sprintf('R^2=%.2f deltaRMSE=%.2f', Rsq,rmse_regression-rmse_mean));
% axis equal
xlim(xl);
ylim([min(Y) max(Y)]);

ylabel(sprintf(' %s zscore',tuning_param_label'));
xlabel('Neural Proj (a.u.)');