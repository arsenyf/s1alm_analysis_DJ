function fn_plot_regression_2D(rel_P,  key, tuning_param_name_2D, tuning_param_label_2D, graphic_param)

num_bins=6;

minimal_num_units_proj_trial=10;

Param = struct2table(fetch (ANL.Parameters,'*'));

time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
time_idx_2plot = (time >=round(key.regression_time_start,4) & time<round(key.regression_time_start,4) + 0.2);


rel_behav= EXP.TrialID & ((EXP.BehaviorTrial * EXP.SessionID * EXP.SessionTraining *ANL.SessionPosition * EXP.TrialName  * ANL.TrialTypeGraphic * ANL.Video1stLickTrialZscoreAllLR) & key  & 'early_lick="no early"'  & ANL.IncludeSession-ANL.ExcludeSession);

rel_Proj = ((rel_P &key & rel_behav)  )*EXP.TrialID*EXP.TrialName;

rel_trials_Proj = EXP.TrialID & ((rel_P &key & rel_behav)  )*EXP.TrialName;
rel_trials_Proj=rel_trials_Proj.proj('trial_uid->trial_uid2');

rel_behav=rel_behav&rel_trials_Proj;


TONGUE = struct2table(fetch((ANL.Video1stLickTrialZscoreAllLR & rel_behav & key)*EXP.TrialID,'*' , 'ORDER BY trial_uid'));

idx_v1=~isoutlier(TONGUE.lick_rt_video_onset);
idx_v2=~isoutlier(table2array(TONGUE(:,tuning_param_name_2D.x)));
idx_v3=~isoutlier(table2array(TONGUE(:,tuning_param_name_2D.y)));

idx_v = idx_v1 & idx_v2 & idx_v3;

TONGUE=TONGUE(idx_v,:);

T(1).param=table2array(TONGUE(:,tuning_param_name_2D.x));
T(2).param=table2array(TONGUE(:,tuning_param_name_2D.y));


key_2D_x_name.tuning_param_name=tuning_param_name_2D.x;
key_2D_y_name.tuning_param_name=tuning_param_name_2D.y;

proj_trial_x=cell2mat(fetchn(rel_Proj & key_2D_x_name,'proj_trial', 'ORDER BY trial_uid'));
proj_trial_y=cell2mat(fetchn(rel_Proj & key_2D_y_name,'proj_trial', 'ORDER BY trial_uid'));

P(1).endpoint=nanmean(proj_trial_x(idx_v,time_idx_2plot),2);
P(2).endpoint=nanmean(proj_trial_y(idx_v,time_idx_2plot),2);


%% Exlude trials with too few neurons to project and outliers in terms of neural avtivity
% too few neurons
num_units_projected=fetchn(rel_Proj & key_2D_x_name,'num_units_projected', 'ORDER BY trial_uid');
include_proj_idx=num_units_projected>minimal_num_units_proj_trial;
include_proj_idx=include_proj_idx(idx_v);
if sum(include_proj_idx)<=10
    return
end
%outliers in terms of neural activity
P_outlier_idx1= isoutlier(P(1).endpoint,'quartiles');
P_outlier_idx2= isoutlier(P(2).endpoint,'quartiles');
P_outlier_idx = P_outlier_idx1 | P_outlier_idx2;

%exluding
P(1).endpoint=(P(1).endpoint(~P_outlier_idx & include_proj_idx));
P(2).endpoint=(P(2).endpoint(~P_outlier_idx & include_proj_idx));

T(1).param=T(1).param(~P_outlier_idx & include_proj_idx,:);
T(2).param=T(2).param(~P_outlier_idx & include_proj_idx,:);

%rescaling
T(1).param= rescale(T(1).param);
T(2).param= rescale(T(2).param);

P_X= rescale(P(1).endpoint);
P_Y= rescale(P(2).endpoint);

%binning the 2D activity space
[N,Xedges,Yedges,binX,binY] = histcounts2(P_X, P_Y, linspace(0,1,num_bins), linspace(0,1,num_bins));
X_centers=Xedges(1:end-1)+mean(diff(Xedges))/2;
Y_centers=Yedges(1:end-1)+mean(diff(Yedges))/2;
minimal_occupancy = 0.005*sum(N(:));
remove_unoccupied_bins=N*0;
remove_unoccupied_bins(find(N(:)<minimal_occupancy))=NaN;


%% Plotting the distribution of the 1st kinematic variable in each neural bin
axes('position',[graphic_param.position_x, graphic_param.position_y, graphic_param.panel_width, graphic_param.panel_height]);

V=T(1).param;
for i_x=1:1:numel(X_centers)
    for i_y=1:1:numel(Y_centers)
        V_2D(i_y,i_x) =mean(V(binX==i_x & binY==i_y));
    end
end
V_2D=V_2D+remove_unoccupied_bins';

imagescnan(X_centers,Y_centers,V_2D)
set(gca,'YDir','normal')
hold on
xlabel(sprintf('%s mode',tuning_param_label_2D.x));
ylabel(sprintf('%s mode',tuning_param_label_2D.y));
axx=gca;
colormap(axx,'jet')
colorbar(axx,'location','northoutside');
title(sprintf('Tongue %s',tuning_param_label_2D.x));
axis equal;
xlim([0 1]);
ylim([0 1]);



%% Plotting the distribution of the 2nd kinematic variable in each neural bin
axes('position',[graphic_param.position_x + graphic_param.panel_width*1.1, graphic_param.position_y, graphic_param.panel_width, graphic_param.panel_height]);

V=T(2).param;
for i_x=1:1:numel(X_centers)
    for i_y=1:1:numel(Y_centers)
        V_2D(i_y,i_x) =mean(V(binX==i_x & binY==i_y));
    end
end
V_2D=V_2D+remove_unoccupied_bins';

imagescnan(X_centers,Y_centers,V_2D)
set(gca,'YDir','normal')
hold on
xlabel(sprintf('%s mode',tuning_param_label_2D.x));
% ylabel(sprintf('%s mode',tuning_param_label_2D.y));
axx=gca;
colormap(axx,'jet')
colorbar(axx,'location','northoutside');
title(sprintf('Tongue %s',tuning_param_label_2D.y));
axis equal;
xlim([0 1]);
ylim([0 1]);


%% Plotting 2D behaviopr only
axes('position',[graphic_param.position_x+0.05, graphic_param.position_y+ graphic_param.panel_height*1.07, graphic_param.panel_width*0.6, graphic_param.panel_height*0.4]);
hold on
plot(T(1).param,T(2).param,'.k','MarkerSize',1);
xlabel(sprintf('Tongue %s',tuning_param_label_2D.x));
ylabel(sprintf('Tongue %s',tuning_param_label_2D.y));
title(sprintf('%s licks',key.lick_direction));
axis equal;
xlim([0 1]);
ylim([0 1]);