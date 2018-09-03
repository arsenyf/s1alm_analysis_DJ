function videoTongue_yaw_distractor()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\'];

flag_used_normalized_video=0; % 1 normalized, 0 non-normalized

% key.trialtype_flag_standard=0;
% key.trialtype_flag_full=0;

% key.brain_area = 'ALM';
% key.hemisphere = 'Left';

% key.training_type = 'distractor';
key.outcome = 'hit';

key.tongue_estimation_type='tip';
k=key;



figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 2 23 25]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -2 0 0]);

panel_width1=0.1;
panel_height1=0.09;
horizontal_distance1=0.13;
vertical_distance1=0.19;

position_x1(1)=0.07;
position_x1(2)=position_x1(1)+horizontal_distance1;
position_x1(3)=position_x1(2)+horizontal_distance1;
position_x1(4)=position_x1(3)+horizontal_distance1;
position_x1(5)=position_x1(4)+horizontal_distance1;
position_x1(6)=position_x1(5)+horizontal_distance1;
position_x1(7)=position_x1(6)+horizontal_distance1;

position_y1(1:14)=0.77;
position_y1(8:14)=position_y1(1)-vertical_distance1;
% position_y1(11:15)=position_y1(6)-vertical_distance1;




if flag_used_normalized_video==1
    session_uid=unique(fetchn( (EXP.SessionID*EXP.SessionTraining*ANL.SessionPosition) & ANL.Video1stLickTrialNormalized  & k,'session_uid'));
else
    session_uid=unique(fetchn( (EXP.SessionID*EXP.SessionTraining*ANL.SessionPosition) & ANL.Video1stLickTrial  & k,'session_uid'));
end
for i_s=1:1:numel(session_uid)
    %     k_s.session_uid=session_uid(i_s);
    
    k_s = k;
    
    if flag_used_normalized_video==1
        rel_behav= ((EXP.BehaviorTrial * EXP.SessionID *EXP.Session* EXP.SessionTraining *ANL.SessionPosition * EXP.TrialName  * ANL.TrialTypeGraphic) & ANL.Video1stLickTrialNormalized  & k  & 'early_lick="no early"' & k_s & (ANL.IncludeSession));
        TONGUE = struct2table(fetch((ANL.Video1stLickTrialNormalized*EXP.TrialID) & rel_behav,'*' , 'ORDER BY trial_uid'));
    else
        rel_behav= ((EXP.BehaviorTrial * EXP.SessionID *EXP.Session* EXP.SessionTraining *ANL.SessionPosition * EXP.TrialName  * ANL.TrialTypeGraphic) & ANL.Video1stLickTrial  & k  & 'early_lick="no early"' & k_s & (ANL.IncludeSession));
        TONGUE = struct2table(fetch((ANL.Video1stLickTrial*EXP.TrialID) & rel_behav,'*' , 'ORDER BY trial_uid'));
    end
    
    idx_v= (TONGUE.lick_rt_video_peak)>=0;
    %     idx_v= (TONGUE.first_lick_rt_video_peak)>0.05 & (TONGUE.first_lick_rt_video_peak)<0.3;
    %     idx_v= (TONGUE.first_lick_rt_videoonset)>0.05 & (TONGUE.first_lick_rt_videoonset)<0.3;
    TONGUE=TONGUE(idx_v,:);
    %     plot(TONGUE.first_lick_yaw,TONGUE.first_lick_peak_x,'.')
    
    
    VariableNames=TONGUE.Properties.VariableNames;
    var_table_offset=5;
    VariableNames=VariableNames(var_table_offset:18);
    
    for i_v=1:1:numel(VariableNames);
        
        
        pos_x=mod(i_v,8)+floor(i_v/8);
        axes('position',[position_x1(pos_x), position_y1(i_v), panel_width1, panel_height1]);
        x=TONGUE{:,i_v+var_table_offset-1};
        idx_outlier = isoutlier(x,'quartiles');
        x=x(~idx_outlier);
        %     histogram(x,[0:0.02:1]);
        h=histogram(x);
        %         h.Normalization = 'countdensity';
        if flag_used_normalized_video==1
            
            xl=[0 1];
        else
            xl= h.BinLimits;
        end
        xlim(xl);
        
        %         ylabel('Counts');
        vname=replace(VariableNames{i_v},'_',' ');
        vname=erase(vname,'lick');
        xlabel(vname);
        yl=[0 max(h.Values)];
        ylim(yl);
        set(gca,'Ytick',100*floor(yl/100))
        if pos_x==1
            ylabel('Counts');
        end
    end
    
    subplot(2,2,2)
    hold on;
    c = categorical([YDIST.name]);
    x = [YDIST.median];
    bar(c,x)
    errorbar(c,[YDIST.median],  [YDIST.stem],'.', 'Color',[0 0 0],'CapSize',4,'MarkerSize',6);
    ylabel('Horizontal offset   (normalized)');
    
    
    subplot(2,2,3)
    hold on;
    c = categorical([YAW.name]);
    x = [YAW.median];
    bar(c,x)
    errorbar(c,[YAW.median],  [YAW.stem],'.', 'Color',[0 0 0],'CapSize',4,'MarkerSize',6);
    ylabel('Yaw (normalized)');
    
    subplot(2,2,4)
    hold on;
    c = categorical([AMP.name]);
    x = [AMP.median];
    bar(c,x)
    errorbar(c,[AMP.median],  [AMP.stem],'.', 'Color',[0 0 0],'CapSize',4,'MarkerSize',6);
    ylabel('Lick Amplitude (normalized)');
    %
    if isempty(dir(dir_save_figure))
        mkdir (dir_save_figure)
    end
    filename=['tongue_behavior_' key.training_type '_' key.outcome];
    figure_name_out=[ dir_save_figure filename];
    eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
    %     eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
    
    clf;
end
end
