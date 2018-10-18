function [R2_LinearRegression,R2_LogisticRegression]=fn_plot_regression_scatter_session(rel_P,  key, tuning_param_label)
R2_LinearRegression=NaN;
R2_LogisticRegression=NaN;

hold on;


minimal_num_units_proj_trial=10;

Param = struct2table(fetch (ANL.Parameters,'*'));

time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};


rel_behav= EXP.TrialID & ((EXP.BehaviorTrial * EXP.SessionID * EXP.SessionTraining *ANL.SessionPosition * EXP.TrialName  * ANL.TrialTypeGraphic * ANL.Video1stLickTrialZscoreAllLR) & key  & 'early_lick="no early"'  & ANL.IncludeSession-ANL.ExcludeSession);

rel_Proj = ((rel_P &key & rel_behav)  )*EXP.TrialID*EXP.TrialName;

rel_trials_Proj = EXP.TrialID & ((rel_P &key & rel_behav)  )*EXP.TrialName;
rel_trials_Proj=rel_trials_Proj.proj('trial_uid->trial_uid2');

rel_behav=rel_behav&rel_trials_Proj;
if rel_behav.count<1
    return
end

TONGUE = struct2table(fetch((ANL.Video1stLickTrialZscoreAllLR & rel_behav & key)*EXP.TrialID,'*' , 'ORDER BY trial_uid'));

Y=table2array(TONGUE(:,key.tuning_param_name));
proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial_uid'));
time_idx_2plot = (time >=round(key.regression_time_start,4) & time<round(key.regression_time_start,4) + 0.2);
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

X=P.endpoint;

[X,Y,Linear, Logistic] = fn_compute_linear_and_logistic_regression (X,Y);

%% Plotting
xvec=min(X):0.01:max(X);
xl=([min(X) max(X)]);
yl=([min(Y) max(Y)]);
xlim(xl);
ylim(yl);


hold on
plot(X,Y,'.k'); %data
plot(xvec,Linear.FittedCurve,'-b','LineWidth',2);
text(xl(1)+diff(xl)*0.1, yl(2)+diff(yl)*0.1, sprintf('R^2='),'Color',[0 0 0]);
text(xl(1)+diff(xl)*0.5, yl(2)+diff(yl)*0.1, sprintf('%.2f', Linear.R2),'Color',[0 0 1]);

if strcmp(key.lick_direction,'all')
    plot(xvec,Logistic.FittedCurve,'-m','LineWidth',2);
    text(xl(1)+diff(xl)*0.9, yl(2)+diff(yl)*0.1, sprintf('%.2f', Logistic.R2),'Color',[1 0 1]);
end

ylabel(sprintf(' %s',tuning_param_label'));
xlabel('Neural Proj (a.u.)');

R2_LinearRegression=Linear.R2;
R2_LogisticRegression=Logistic.R2;
