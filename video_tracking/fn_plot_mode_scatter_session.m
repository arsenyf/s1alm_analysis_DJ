function [R2_LinearRegression,R2_LogisticRegression]=fn_plot_mode_scatter_session(rel_P, key, tuning_param_label)
R2_LinearRegression=NaN;
R2_LogisticRegression=NaN;

hold on;


minimal_num_units_proj_trial=5;

Param = struct2table(fetch (ANL.Parameters,'*'));

time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};


rel_behav= EXP.TrialID & ((EXP.BehaviorTrial * EXP.SessionID * EXP.SessionTraining *ANL.SessionPosition * EXP.TrialName  * ANL.TrialTypeGraphic * ANL.Video1stLickTrialZscoreAllLR) & key  & 'early_lick="no early"'  & ANL.IncludeSession-ANL.ExcludeSession);

rel_Proj = ((rel_P &key & rel_behav)  )*EXP.TrialID*EXP.TrialName;


mode_time1_st=unique(fetchn(ANL.Mode&rel_Proj,'mode_time1_st'));
mode_time1_end=unique(fetchn(ANL.Mode&rel_Proj,'mode_time1_end'));


rel_trials_Proj = EXP.TrialID & ((rel_P &key & rel_behav)  )*EXP.TrialName;
rel_trials_Proj=rel_trials_Proj.proj('trial_uid->trial_uid2');

rel_behav=rel_behav&rel_trials_Proj;
if rel_behav.count<1
    return
end

TONGUE = struct2table(fetch((ANL.Video1stLickTrialZscoreAllLR & rel_behav & key)*EXP.TrialID,'*' , 'ORDER BY trial_uid'));

Y=table2array(TONGUE(:,key.tuning_param_name));
proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial_uid'));
time_idx_2plot = (time >=mode_time1_st & time<mode_time1_end);
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

Y= rescale(Y);
X=rescale(P.endpoint,-5,5);

%% Linear regression
Predictor = [ones(size(X,1),1) X];
[beta,~,~,~,stats]= regress(Y,Predictor);
Rsq = stats(1);  %stats [Rsq, F-statistic, p-value, and an estimate of the error variance.]
% regression_p=stats(3);
YRegLinear =  beta(1) + beta(2)*X;


%% Logistic regression (fitting a logistic function)
% sigfunc = @(A, x)(A(1) ./ (1 + exp(-A(2)*x)))
logisticfunc = @(A, x) ( (A(1) ./ (1 + exp(-A(3)*(x-A(4))))) +A(2)); %Logistic function

% Initial values fed into the iterative algorithm
A0(1) = 1; % Stretch in Y
A0(2)=0; % Y baseline
A0(3)=1; % slope
A0(4)=0.5; % intersect

A_fit = nlinfit(X, Y, logisticfunc, A0);
YLogisticRegFit= logisticfunc(A_fit,X);


%% Computing Root mean square error of both types of fits (linear and logistic)

% RMSE_LinearRegression = sqrt(mean((Y - YRegLinear).^2));  % Root Mean Squared Error
% RMSE_LogisticRegression = sqrt(mean((Y - YLogisticRegFit).^2));  % Root Mean Squared Error
% RMSE_mean = sqrt(mean((Y - mean(Y)).^2));  % Root Mean Squared Error - assuming just the average of the distribution

R2_LinearRegression=fn_rsquare (Y,YRegLinear);
R2_LogisticRegression=fn_rsquare (Y,YLogisticRegFit);


%% Plotting
hold on
plot(X,Y,'.k'); %data

%computing lines
xvec=min(X):0.01:max(X);
YRegLinear_line =  beta(1) + beta(2)*xvec;
YLogisticRegFit_line =  logisticfunc(A_fit,xvec);

plot(xvec,YRegLinear_line,'-b','LineWidth',2);
plot(xvec,YLogisticRegFit_line,'-m','LineWidth',2);

xl=([min(X) max(X)]);
yl=([min(Y) max(Y)]);
xlim(xl);
ylim(yl);
text(xl(1)+diff(xl)*-0.1, yl(2)+diff(yl)*0.1, sprintf('R^2='),'Color',[0 0 0]);
text(xl(1)+diff(xl)*0.5, yl(2)+diff(yl)*0.1, sprintf('%.2f', R2_LinearRegression),'Color',[0 0 1]);
text(xl(1)+diff(xl)*0.9, yl(2)+diff(yl)*0.1, sprintf('%.2f', R2_LogisticRegression),'Color',[1 0 1]);

% title(sprintf('R^2=%.2f dRMSE=%.2f', Rsq,rmse_regression-rmse_mean));


% plot(P.endpoint,Y,'.','MarkerSize',2);
% 
% 
% xl=[min([P.endpoint]), max([P.endpoint])];
% 
% 
% YRegLiniearLine =  beta(1) + beta(2)*xl;
% plot(xl,YRegLiniearLine,'k-')
% title(sprintf('R^2=%.2f dRMSE=%.2f', Rsq,rmse_regression-rmse_mean));
% % axis equal


vname=replace(key.tuning_param_name,'_',' ');
vname=erase(vname,'lick');

ylabel(sprintf(' %s',tuning_param_label'));
xlabel('Neural Proj (a.u.)');