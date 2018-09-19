function videoTongue_neuralActivitySpaceRegression()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\'];


figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 2 23 25]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -2 0 0]);


Param = struct2table(fetch (ANL.Parameters,'*'));
minimal_num_units_proj_trial = 20%Param.parameter_value{(strcmp('minimal_num_units_proj_trial',Param.parameter_name))};
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};


key.brain_area = 'ALM';
key.hemisphere = 'Left';
% key.trialtype_left_and_right_no_distractors=1;

key.unit_quality = 'ok or good';
key.cell_type = 'Pyr';
% key.training_type = 'regular';
% key.outcome = 'hit';
key.tongue_estimation_type='tip';
key.lick_direction='left';

k=key;

k_proj.mode_weights_sign='all';
k_proj.lick_direction=key.lick_direction;
k_proj.cell_type=key.cell_type;

if strcmp(k.lick_direction,'all')
    k=rmfield(k,'lick_direction');
end

session_uid=unique(fetchn( (EXP.SessionID*EXP.SessionTraining*ANL.SessionPosition) & ANL.Video1stLickTrialNormalized  & k,'session_uid'));

tuning_param_name{1}='lick_horizoffset_relative';
tuning_param_name{2}='lick_rt_video_onset';
tpoint=-3;
regression_time_start(1)=round(tpoint,4);
regression_time_start(2)=round(tpoint,4);
time_idx_2plot = (time >=round(tpoint,4) & time<round(tpoint,4) + 0.25);

for i_s=1:1:numel(session_uid)
    V_2D=[];
%     k_s.session_uid=session_uid(i_s); 
    k_s = k;
    rel_behav= EXP.TrialID &((EXP.BehaviorTrial * EXP.SessionID * EXP.SessionTraining *ANL.SessionPosition * EXP.TrialName  * ANL.TrialTypeGraphic * ANL.LickDirectionTrial) & ANL.Video1stLickTrialNormalized   & k  & 'early_lick="no early"' & k_s & ANL.IncludeSession)-ANL.ExcludeSession;
    TONGUE = struct2table(fetch((ANL.Video1stLickTrialNormalized & rel_behav)*EXP.TrialID,'*' , 'ORDER BY trial_uid'));
    
    idx_v= (TONGUE.lick_rt_video_onset)<=50;
    TONGUE=TONGUE(idx_v,:);
    
    num=1;
    k_proj.tuning_param_name=tuning_param_name{num};
    k_proj.regression_time_start=regression_time_start(num);
    tic
    rel_Proj = ((ANL.RegressionProjTrialNormalized & rel_behav) &k_proj  )*EXP.TrialID*EXP.TrialName;
    rel_Proj.count
    toc
    proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial_uid'));
    P(num).endpoint=mean(proj_trial(idx_v,time_idx_2plot),2);
    %     hist(endpoint)
    
    num=2;
    k_proj.tuning_param_name=tuning_param_name{num};
    k_proj.regression_time_start=regression_time_start(num);
    rel_Proj = ((ANL.RegressionProjTrialNormalized  & rel_behav) &k_proj )*EXP.TrialID*EXP.TrialName;
    proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial_uid'));
    P(num).endpoint=mean(proj_trial(idx_v,time_idx_2plot),2);
    
    %exlude outliers
    P(1).outlier = isoutlier(P(1).endpoint,'quartiles');
    P(2).outlier = isoutlier(P(2).endpoint,'quartiles');
    P_outlier_idx = P(1).outlier | P(2).outlier;
    
    %exlude trials with too few neurons to project    
    num_units_projected=fetchn(rel_Proj,'num_units_projected', 'ORDER BY trial_uid');
    include_proj_idx=num_units_projected>minimal_num_units_proj_trial;
    include_proj_idx=include_proj_idx(idx_v);
    
    P(1).endpoint=P(1).endpoint(~P_outlier_idx & include_proj_idx);
    P(2).endpoint=P(2).endpoint(~P_outlier_idx & include_proj_idx);
    TONGUE=TONGUE(~P_outlier_idx & include_proj_idx,:);
    
    
    
    trial_type_name=fetchn((EXP.TrialName&rel_behav)*EXP.TrialID,'trial_type_name', 'ORDER BY trial_uid');
    trial_type_name=trial_type_name(idx_v);
    trial_type_name=trial_type_name(~P_outlier_idx & include_proj_idx,:);
    
    un_name=unique(trial_type_name);
    
    %     for i_n = 1:1:numel(un_name)
    %         idx=contains(trial_type_name,un_name(i_n));
    %
    %         RT(i_n).name=un_name(i_n);
    %         v=TONGUE.lick_rt_video_onset(idx);
    %         RT(i_n).value=v;
    %         RT(i_n).median=nanmedian(v);
    %         RT(i_n).stem=nanstd(v)./sqrt(numel(v));
    %         RT(i_n).idx=idx;
    %
    %         YAW(i_n).name=un_name(i_n);
    %         v=TONGUE.lick_yaw_avg(idx);
    %         YAW(i_n).value=v;
    %         YAW(i_n).median=nanmedian(v);
    %         YAW(i_n).stem=nanstd(v)./sqrt(numel(v));
    %         YAW(i_n).YAW=idx;
    %
    %     end
    
    idx_1=strcmp(trial_type_name,'l_-1.6Full');
    idx_2=strcmp(trial_type_name,'l');
    hold on
    %     plot(P(1).endpoint, P(2).endpoint,'.b')
    %     plot(P(1).endpoint, P(2).endpoint,'.r')
    %     Xedges=[0, 0.3:0.05:0.7, 1];
    %         Yedges=[0, 0.3:0.05:0.7, 1];
    
    [N,Xedges,Yedges,binX,binY] = histcounts2(P(1).endpoint, P(2).endpoint);
    X_centers=Xedges(1:end-1)+mean(diff(Xedges))/2;
    Y_centers=Yedges(1:end-1)+mean(diff(Yedges))/2;
    minimal_occupancy = 0.005*sum(N(:));
    remove_unoccupied_bins=N*0;
    remove_unoccupied_bins(find(N(:)<minimal_occupancy))=NaN;
    
    %     %     subplot(3,3,1)
    %     ax1= subplot(3,3,1);
    %
    %     V=(TONGUE.lick_yaw_peak_relative);
    %     for i_x=1:1:numel(X_centers)
    %         for i_y=1:1:numel(Y_centers)
    %             V_2D(i_y,i_x) =mean(V(binX==i_x & binY==i_y));
    %         end
    %     end
    %     V_2D=V_2D+remove_unoccupied_bins';
    %     imagescnan(X_centers,Y_centers,V_2D)
    %     set(gca,'YDir','normal')
    %     hold on
    %     %     plot(P(1).endpoint, P(2).endpoint,'.k')
    %     xlabel(mode_name{1});
    %     ylabel(mode_name{2});
    %     %     title(sprintf('%d %s suid=%d',animal,date, k_s.session_uid));
    %     %     colormap(ax1,bluewhitered)
    %     colormap(ax1,jet)
    %     cb1 = colorbar(ax1);
    %
    %     %     idxa=V<-10 | V>10
    %     idxa=V>-20 & V<20;
    %     %     plot(P(1).endpoint(idxa), P(2).endpoint(idxa),'.k')
    %     plot(P(1).endpoint, P(2).endpoint,'.b')
    %
    %     plot(P(1).endpoint(idx_l), P(2).endpoint(idx_l),'.k')
    %
    %     idx_l
    % ax2=axes('position',[0.3 0.7  0.2 0.2]);
    
    ax2=     subplot(3,3,2);
        V=TONGUE.lick_horizoffset;
%     V=abs(TONGUE.lick_horizoffset-0.5);
    for i_x=1:1:numel(X_centers)
        for i_y=1:1:numel(Y_centers)
            V_2D(i_y,i_x) =mean(V(binX==i_x & binY==i_y));
        end
    end
    V_2D=V_2D+remove_unoccupied_bins';
    imagescnan(X_centers,Y_centers,V_2D)
    set(gca,'YDir','normal')
    hold on
    %     plot(P(1).endpoint, P(2).endpoint,'.k')
    xlabel(tuning_param_name{1});
    ylabel(tuning_param_name{2});
    %    cm2=colormap(cool)
    %     c2=colorbar
    %         cbfreeze(c2,cm2);
    colormap(ax2,'jet')
    cb2 = colorbar(ax2);
    
    title('horizoffset');
    
    
    ax3=subplot(3,3,3);
    V=TONGUE.lick_rt_video_onset;
    for i_x=1:1:numel(X_centers)
        for i_y=1:1:numel(Y_centers)
            V_2D(i_y,i_x) =mean(V(binX==i_x & binY==i_y));
        end
    end
    V_2D=V_2D+remove_unoccupied_bins';
    imagescnan(X_centers,Y_centers,V_2D)
    set(gca,'YDir','normal')
    hold on
    %     plot(P(1).endpoint, P(2).endpoint,'.k')
    xlabel(tuning_param_name{1});
    ylabel(tuning_param_name{2});
    colormap(ax3,'jet')
    cb3 = colorbar(ax3);
    title('RT');
    
    
    
    %     subplot(3,3,4)
    %     hold on;
    %     plot(P(1).endpoint,TONGUE.lick_yaw_peak_relative,'.k')
    %     plot(P(1).endpoint(idx_l),TONGUE.lick_yaw_peak_relative(idx_l),'.r')
    %     xlabel(mode_name{1});
    %     ylabel('Yaw (normalized)');
    %         ylim([0 1]);
    %     xlim([0 1]);
    
    subplot(3,3,5)
    hold on;
    plot(P(1).endpoint,TONGUE.lick_horizoffset,'.k')
    plot(P(1).endpoint(idx_1),TONGUE.lick_horizoffset(idx_1),'.b')
    plot(P(1).endpoint(idx_2),TONGUE.lick_horizoffset(idx_2),'.r')
    
    xlabel(tuning_param_name{1});
    ylabel('horizoffset');
    %     ylim([0 1]);
    xlim([0 1]);
    
    subplot(3,3,8)
    plot(P(1).endpoint,TONGUE.lick_rt_video_onset,'.k')
    xlabel(tuning_param_name{1});
    ylabel('RT');
    ylim([0 1]);
    xlim([0 1]);
    
    
    %     subplot(3,3,7)
    %     plot(P(2).endpoint,TONGUE.lick_yaw_peak_relative,'.k')
    %     xlabel(mode_name{2});
    %     ylabel('Yaw (normalized)');
    %         ylim([0 1]);
    %     xlim([0 1]);
    
    subplot(3,3,6)
    plot(P(2).endpoint,TONGUE.lick_horizoffset,'.k')
    xlabel(tuning_param_name{2});
    ylabel('horizoffset');
    %     ylim([0 1]);
    xlim([0 1]);
    
    subplot(3,3,9)
    plot(P(2).endpoint,TONGUE.lick_rt_video_onset	, '.k')
    xlabel(tuning_param_name{2});
    ylabel('RT');
    ylim([0 1]);
    xlim([0 1]);
    
    subplot(3,3,4)
    histogram(TONGUE.lick_horizoffset,[0:0.02:1]);
    ylabel('Counts');
    xlabel('horizoffset');
    
    subplot(3,3,7)
    histogram(TONGUE.lick_rt_video_onset,[0:0.02:1]);
    ylabel('Counts');
    xlabel('RT');
    
    subplot(3,3,1)
    hold on
    plot(TONGUE.lick_horizoffset,TONGUE.lick_rt_video_onset, '.k')
    plot(TONGUE.lick_horizoffset(idx_1),TONGUE.lick_rt_video_onset(idx_1),'.b')
    plot(TONGUE.lick_horizoffset(idx_2),TONGUE.lick_rt_video_onset(idx_2),'.r')
    ylabel('RT');
    xlabel('horizoffset')
    ylim([0 1]);
    xlim([0 1]);
    
    %     if isempty(dir(dir_save_figure))
    %
    %         mkdir (dir_save_figure)
    %     end
    %     filename=['tongue_neural_' key.training_type '_' key.outcome];
    %     figure_name_out=[ dir_save_figure filename];
    %     eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
    clf
end
