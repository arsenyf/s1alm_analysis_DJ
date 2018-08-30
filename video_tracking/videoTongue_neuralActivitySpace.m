function videoTongue_neuralActivitySpace()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
% dir_save_figure = [dir_root 'Results\Population\activitySpace\Modes\Decoding_before_perturbation\'];

figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 2 23 25]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -2 0 0]);


Param = struct2table(fetch (ANL.Parameters,'*'));
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
%     time_idx_2plot = (time >=-0.2 & time<0);
time_idx_2plot = (time >=-0.5 & time<0);

key.brain_area = 'ALM';
key.unit_quality = 'ok or good';
key.cell_type = 'Pyr'
key.training_type = 'distractor';

% key.subject_id = 365939;
k=key;
k_estimation.tongue_estimation_type='center';

k_proj.mode_weights_sign='all';

session_uid=unique(fetchn(EXP.BehaviorTrial*EXP.SessionID & ANL.VideoLickOnsetTrial,'session_uid'));

mode_name{1}='LateDelay';
mode_name{2}='Ramping Orthog.';
% mode_name{1}='Right vs. baseline';
% mode_name{2}='Left vs. baseline';
% mode_name{1}='LateDelay Orthog.';
% mode_name{2}='Ramping Orthog.';

for i_s=1:1:numel(session_uid)
    V_2D=[];
    k_s.brain_area = 'ALM';  %k_s.session_uid=session_uid(i_s);
    kk=fetch(EXP.BehaviorTrial * EXP.SessionID * EXP.SessionTraining & ANL.VideoLickOnsetTrial  & k  & 'early_lick="no early"' & 'outcome="hit"' & k_s );
    %     animal=fetchn(EXP.Session*EXP.SessionID & k_s,'subject_id')
    %     date=fetchn(EXP.Session*EXP.SessionID & k_s,'session_date')
    
    TONGUE = struct2table(fetch(ANL.VideoLickOnsetTrial & k_estimation & kk  ,'*', 'ORDER BY trial'));
    
    idx_v= (TONGUE.first_lick_rt_video_peak)>=0;
    %         idx_v= (TONGUE.first_lick_rt_video_peak)>0.05 & (TONGUE.first_lick_rt_video_peak)<0.3;
    
    %     idx_v= (TONGUE.first_lick_rt_videoonset)>0.05 & (TONGUE.first_lick_rt_videoonset)<0.3;
    TONGUE=TONGUE(idx_v,:);
    %     plot(TONGUE.first_lick_yaw,TONGUE.first_lick_peak_x,'.')
    
    num=1;
    k_proj.mode_type_name=mode_name{num};
    rel_Proj = ANL.ProjTrialNormalized & kk  & k & k_proj;
    proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial'));
    P(num).endpoint=mean(proj_trial(idx_v,time_idx_2plot),2);
    %     hist(endpoint)
    
    num=2;
    k_proj.mode_type_name=mode_name{num};
    rel_Proj = ANL.ProjTrialNormalized & kk  & k & k_proj;
    proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial'));
    P(num).endpoint=mean(proj_trial(idx_v,time_idx_2plot),2);
    
    P(1).outlier = isoutlier(P(1).endpoint,'quartiles');
    P(2).outlier = isoutlier(P(2).endpoint,'quartiles');
    P_outlier_idx = P(1).outlier | P(2).outlier;
    
    P(1).endpoint=P(1).endpoint(~P_outlier_idx);
    P(2).endpoint=P(2).endpoint(~P_outlier_idx);
    TONGUE=TONGUE(~P_outlier_idx,:);
    
    
    trial_type_name=fetchn(EXP.TrialName & kk,'trial_type_name', 'ORDER BY trial');
    trial_type_name=trial_type_name(~P_outlier_idx,:);
    
    un_name=unique(trial_type_name);
    
    for i_n = 1:1:numel(un_name)
        idx=contains(trial_type_name,un_name(i_n));
        
        RT(i_n).name=un_name(i_n);
        v=TONGUE.first_lick_rt_video_onset(idx);
        RT(i_n).value=v;
        RT(i_n).median=nanmedian(v);
        RT(i_n).stem=nanstd(v)./sqrt(numel(v));
        RT(i_n).idx=idx;
        
        YAW(i_n).name=un_name(i_n);
        v=TONGUE.first_lick_yaw_protrusion(idx);
        YAW(i_n).value=v;
        YAW(i_n).median=nanmedian(v);
        YAW(i_n).stem=nanstd(v)./sqrt(numel(v));
        YAW(i_n).YAW=idx;
        
    end
    
    idx_l=strcmp(trial_type_name,'l');
    hold on
    %     plot(P(1).endpoint, P(2).endpoint,'.b')
    %     plot(P(1).endpoint, P(2).endpoint,'.r')
    %     Xedges=[0, 0.3:0.05:0.7, 1];
    %         Yedges=[0, 0.3:0.05:0.7, 1];
    
    [N,Xedges,Yedges,binX,binY] = histcounts2(P(1).endpoint, P(2).endpoint);
    X_centers=Xedges(1:end-1)+mean(diff(Xedges))/2;
    Y_centers=Yedges(1:end-1)+mean(diff(Yedges))/2;
    minimal_occupancy = 0.002*sum(N(:));
    remove_unoccupied_bins=N*0;
    remove_unoccupied_bins(find(N(:)<minimal_occupancy))=NaN;
    
    %     subplot(3,3,1)
    ax1= subplot(3,3,1);
    
    V=(TONGUE.lick_yaw_peak_relative);
    for i_x=1:1:numel(X_centers)
        for i_y=1:1:numel(Y_centers)
            V_2D(i_y,i_x) =mean(V(binX==i_x & binY==i_y));
        end
    end
    V_2D=V_2D+remove_unoccupied_bins';
    imagescnan(X_centers,Y_centers,V_2D)
    set(gca,'YDir','normal')
    hold on
    %     plot(P(1).endpoint, P(2).endpoint,'.')
    xlabel(mode_name{1});
    ylabel(mode_name{2});
    %     title(sprintf('%d %s suid=%d',animal,date, k_s.session_uid));
    %     colormap(ax1,bluewhitered)
    colormap(ax1,jet)
    cb1 = colorbar(ax1);
    
    %     idxa=V<-10 | V>10
    idxa=V>-20 & V<20;
    %     plot(P(1).endpoint(idxa), P(2).endpoint(idxa),'.')
    plot(P(1).endpoint, P(2).endpoint,'.b')
    
    plot(P(1).endpoint(idx_l), P(2).endpoint(idx_l),'.k')
    
    idx_l
    % ax2=axes('position',[0.3 0.7  0.2 0.2]);
    
    ax2=     subplot(3,3,2);
    V=TONGUE.lick_horizdist_peak_relative;
    for i_x=1:1:numel(X_centers)
        for i_y=1:1:numel(Y_centers)
            V_2D(i_y,i_x) =mean(V(binX==i_x & binY==i_y));
        end
    end
    V_2D=V_2D+remove_unoccupied_bins';
    imagescnan(X_centers,Y_centers,V_2D)
    set(gca,'YDir','normal')
    hold on
    %     plot(P(1).endpoint, P(2).endpoint,'.')
    xlabel(mode_name{1});
    ylabel(mode_name{2});
    %    cm2=colormap(cool)
    %     c2=colorbar
    %         cbfreeze(c2,cm2);
    colormap(ax2,'jet')
    cb2 = colorbar(ax2);
    
    
    
    ax3=subplot(3,3,3);
    V=TONGUE.first_lick_rt_video_onset;
    for i_x=1:1:numel(X_centers)
        for i_y=1:1:numel(Y_centers)
            V_2D(i_y,i_x) =mean(V(binX==i_x & binY==i_y));
        end
    end
    V_2D=V_2D+remove_unoccupied_bins';
    imagescnan(X_centers,Y_centers,V_2D)
    set(gca,'YDir','normal')
    hold on
    %     plot(P(1).endpoint, P(2).endpoint,'.')
    xlabel(mode_name{1});
    ylabel(mode_name{2});
    colormap(ax3,'jet')
    cb3 = colorbar(ax3);
    
    
    
    subplot(3,3,4)
    hold on;
    plot(P(1).endpoint,TONGUE.lick_yaw_peak_relative,'.')
    plot(P(1).endpoint(idx_l),TONGUE.lick_yaw_peak_relative(idx_l),'.r')
    xlabel(mode_name{1});
    ylabel('Yaw (deg');
    
    subplot(3,3,5)
    hold on;
    plot(P(1).endpoint,TONGUE.lick_horizdist_peak_relative,'.')
        plot(P(1).endpoint(idx_l),TONGUE.lick_horizdist_peak_relative(idx_l),'.r')
    xlabel(mode_name{1});
    ylabel('HoriztDist');
    
    subplot(3,3,6)
    plot(P(1).endpoint,TONGUE.first_lick_rt_video_onset,'.')
    xlabel(mode_name{1});
    ylabel('RT(VideoOnset)');
    
    
    subplot(3,3,7)
    plot(P(2).endpoint,TONGUE.lick_yaw_peak_relative,'.')
    xlabel(mode_name{2});
    ylabel('Yaw (deg');
    
    subplot(3,3,8)
    plot(P(2).endpoint,TONGUE.lick_horizdist_peak_relative,'.')
    xlabel(mode_name{2});
    ylabel('HoriztDist');
    
    subplot(3,3,9)
    plot(P(2).endpoint,TONGUE.first_lick_rt_video_onset	, '.')
    xlabel(mode_name{2});
    ylabel('RT(VideoOnset)');
    
    histogram(TONGUE.first_lick_yaw_protrusion)
    clf
end
