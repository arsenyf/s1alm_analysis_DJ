function videoTongue_yaw_distractor()
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
time_idx_2plot = (time >=-0.2 & time<0);


key.training_type = 'distractor';

% key.subject_id = 365939;
k=key;
k_estimation.tongue_estimation_type='center';


session_uid=unique(fetchn(EXP.BehaviorTrial*EXP.SessionID*EXP.SessionTraining & ANL.VideoLickOnsetTrial & key,'session_uid'));

for i_s=1:1:numel(session_uid)
    V_2D=[];
    k_s.session_uid=session_uid(i_s);
    kk=fetch(EXP.BehaviorTrial & (EXP.SessionID & k_s) *EXP.SessionTraining & ANL.VideoLickOnsetTrial  & k  & 'early_lick="no early"' & 'outcome="hit"'  );
    %     animal=fetchn(EXP.Session*EXP.SessionID & k_s,'subject_id')
    %     date=fetchn(EXP.Session*EXP.SessionID & k_s,'session_date')
    
    TONGUE = struct2table(fetch(ANL.VideoLickOnsetTrial & k_estimation & kk  ,'*', 'ORDER BY trial'));
    
    idx_v= (TONGUE.first_lick_rt_video_peak)>=0;
    %         idx_v= (TONGUE.first_lick_rt_video_peak)>0.05 & (TONGUE.first_lick_rt_video_peak)<0.3;
    
    %     idx_v= (TONGUE.first_lick_rt_videoonset)>0.05 & (TONGUE.first_lick_rt_videoonset)<0.3;
    TONGUE=TONGUE(idx_v,:);
    %     plot(TONGUE.first_lick_yaw,TONGUE.first_lick_peak_x,'.')
    
    trial_type_name=fetchn(EXP.TrialName & kk,'trial_type_name', 'ORDER BY trial');
    trial_type_name=trial_type_name(idx_v);
    un_name=unique(trial_type_name);
    RT=[];
    YAW=[];
    AMP=[];
    YDIST=[];
    for i_n = 1:1:numel(un_name)
        idx=contains(trial_type_name,un_name(i_n));
        
        RT(i_n).name=un_name(i_n);
        v=TONGUE.first_lick_rt_video_onset(idx);
        RT(i_n).value=v;
        RT(i_n).median=nanmedian(v);
        RT(i_n).stem=nanstd(v)./sqrt(numel(v));
        
        YAW(i_n).name=un_name(i_n);
        v=TONGUE.lick_yaw_peak_relative(idx);
        YAW(i_n).value=v;
        YAW(i_n).median=nanmedian(v);
        YAW(i_n).stem=nanstd(v)./sqrt(numel(v));
        
        AMP(i_n).name=un_name(i_n);
        v=TONGUE.first_lick_amplitude(idx);
        AMP(i_n).value=v;
        AMP(i_n).median=nanmedian(v);
        AMP(i_n).stem=nanstd(v)./sqrt(numel(v));
        
        YDIST(i_n).name=un_name(i_n);
        v=TONGUE.lick_horizdist_peak_relative(idx);
        YDIST(i_n).value=v;
        YDIST(i_n).median=nanmedian(v);
        YDIST(i_n).stem=nanstd(v)./sqrt(numel(v));
    end
    subplot(2,2,1)
    hold on;
    c = categorical([RT.name]);
    x = [RT.median];
    bar(c,x);
    errorbar(c,[RT.median],  [RT.stem],'.', 'Color',[0 0 0],'CapSize',4,'MarkerSize',6);
    
    ylabel('RT (s)');
    
    subplot(2,2,2)
    hold on;
    c = categorical([YAW.name]);
    x = [YAW.median];
    bar(c,x)
    errorbar(c,[YAW.median],  [YAW.stem],'.', 'Color',[0 0 0],'CapSize',4,'MarkerSize',6);
    ylabel('Yaw(deg)');
    
    subplot(2,2,3)
    hold on;
    c = categorical([AMP.name]);
    x = [AMP.median];
    bar(c,x)
    errorbar(c,[AMP.median],  [AMP.stem],'.', 'Color',[0 0 0],'CapSize',4,'MarkerSize',6);
    ylabel('AMP (pixel)');
    
    subplot(2,2,4)
    hold on;
    c = categorical([YDIST.name]);
    x = [YDIST.median];
    bar(c,x)
    errorbar(c,[YDIST.median],  [YDIST.stem],'.', 'Color',[0 0 0],'CapSize',4,'MarkerSize',6);
    ylabel('Ydist (pixel)');
    
    clf;
end
