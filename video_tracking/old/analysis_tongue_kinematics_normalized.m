function analysis_tongue_kinematics_normalized()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\'];

flag_used_normalized_video=1; % 1 normalized, 0 non-normalized

% key.trialtype_flag_standard=0;
% key.trialtype_flag_full=1;
key.trialtype_left_and_right_no_distractors=1;

% key.training_type = 'regular';
% key.outcome = 'hit';

key.tongue_estimation_type='tip';
k=key;



figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 2 23 25]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -2 0 0]);

panel_width1=0.1;
panel_height1=0.09;
horizontal_distance1=0.135;
vertical_distance1=0.15;

position_x1(1)=0.07;
position_x1(2)=position_x1(1)+horizontal_distance1;
position_x1(3)=position_x1(2)+horizontal_distance1;
position_x1(4)=position_x1(3)+horizontal_distance1;
position_x1(5)=position_x1(4)+horizontal_distance1;
position_x1(6)=position_x1(5)+horizontal_distance1;
position_x1(7)=position_x1(6)+horizontal_distance1;

position_y1(1:14)=0.85;
position_y1(8:14)=position_y1(1)-vertical_distance1;
% position_y1(11:15)=position_y1(6)-vertical_distance1;

horizontal_distance2=0.16;
vertical_distance2=0.15;

position_x2(1)=0.07;
position_x2(2)=position_x2(1)+horizontal_distance2;
position_x2(3)=position_x2(2)+horizontal_distance2;
position_x2(4)=position_x2(3)+horizontal_distance2;
position_x2(5)=position_x2(4)+horizontal_distance2;
position_x2(6)=position_x2(5)+horizontal_distance2;

position_y2(1:14)=0.55;
position_y2(6:14)=position_y2(1)-vertical_distance2;


horizontal_distance3=0.16;
vertical_distance3=0.14;

position_x3(1)=0.07;
position_x3(2)=position_x3(1)+horizontal_distance3;
position_x3(3)=position_x3(2)+horizontal_distance3;
position_x3(4)=position_x3(3)+horizontal_distance3;
position_x3(5)=position_x3(4)+horizontal_distance3;
position_x3(6)=position_x3(5)+horizontal_distance3;

position_y3(1)=0.25;
position_y3(2)=position_y3(1)-vertical_distance3;


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
    
    idx_v= (TONGUE.lick_rt_video_onset)>=0;
    TONGUE=TONGUE(idx_v,:);
    
    
    VariableNames=TONGUE.Properties.VariableNames';
    var_table_offset=5;
    VariableNames=VariableNames(var_table_offset:end-1);
    
    for i_v=1:1:numel(VariableNames)-1
        
        pos_x=mod(i_v,8)+floor(i_v/8);
        axes('position',[position_x1(pos_x), position_y1(i_v), panel_width1, panel_height1]);
        x=TONGUE{:,i_v+var_table_offset-1};
        idx_outlier = isoutlier(x,'quartiles');
        x=x(~idx_outlier);
        h=histogram(x);
        if flag_used_normalized_video==1
            xl=[0 1];
        else
            xl= h.BinLimits;
        end
        xlim(xl);
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
    
    T=TONGUE(:,var_table_offset:end-1);
    variables_pairs = [12,1; 12,4; 12,6; 12,14; 11,15; 1,3; 1,4; 1,6; 1,14; 1,15];
    
    
    subsample_v=(1:4:size(T,1));
    
    
    
    for i_v=1:1:size(variables_pairs,1)
        
        pos_x=mod(i_v,6)+floor(i_v/6);
        axes('position',[position_x2(pos_x), position_y2(i_v), panel_width1, panel_height1]);
        x=TONGUE{:,variables_pairs(i_v,1)+var_table_offset-1};
        y=TONGUE{:,variables_pairs(i_v,2)+var_table_offset-1};
        r=corr([x,y],'Rows','pairwise');
        r=r(2);
        plot(x(subsample_v),y(subsample_v),'.')
        title(sprintf('r = %.2f',r));
        %         idx_outlier = isoutlier(x,'quartiles');
        %         x=x(~idx_outlier);
        %         h=histogram(x);
        if flag_used_normalized_video==1
            xlim([0 1]);
            ylim([0 1]);
            set(gca,'Ytick',[0 1]);
        end
        %         xlim(xl);
        vname=replace(VariableNames{variables_pairs(i_v,1)},'_',' ');
        vname=erase(vname,'lick');
        xlabel(vname);
        
        vname=replace(VariableNames{variables_pairs(i_v,2)},'_',' ');
        vname=erase(vname,'lick');
        ylabel(vname);
        %
        %         yl=[0 max(h.Values)];
        %         ylim(yl);
        
    end
    
    
    %% PCA on x,y, onset
    T_selected=T(:,[1,12,14]);
    X=table2array(T_selected);
    X(isnan(X))=0;
%   X=zscore(X,0,1);
    [coeff,score,~, ~, explained] = pca(X);
    %        [U,S,V]  = svd(X);
%     [L1,TT] = rotatefactors(coeff);
    
    axes('position',[position_x3(1), position_y3(1), panel_width1, panel_height1]);
    plot(score(subsample_v,1),score(subsample_v,2),'.')
    xlim([-1 1])
    ylim([-1 1])
    xlabel('PC1');
    ylabel('PC2');
    
    axes('position',[position_x3(2), position_y3(1), panel_width1, panel_height1]);
    plot(score(subsample_v,1),score(subsample_v,3),'.')
    xlim([-1 1])
    ylim([-1 1])
    xlabel('PC1');
    ylabel('PC3');
    title('PCA on x, y, onset');
    
    axes('position',[position_x3(3), position_y3(1), panel_width1, panel_height1]);
    plot(score(subsample_v,2),score(subsample_v,3),'.')
    xlim([-1 1])
    ylim([-1 1])
    xlabel('PC2');
    ylabel('PC3');
    
     %% PCA on x,y,linear vel,angular vel, onset
    T_selected=T(:,[1,4,6,12,14]);
    X=table2array(T_selected);
    X(isnan(X))=0;
%   X=zscore(X,0,1);
    [coeff,score,~, ~, explained] = pca(X);
    %        [U,S,V]  = svd(X);
%     [L1,TT] = rotatefactors(coeff);
    
    axes('position',[position_x3(1), position_y3(2), panel_width1, panel_height1]);
    plot(score(subsample_v,1),score(subsample_v,2),'.')
    xlim([-1 1])
    ylim([-1 1])
    xlabel('PC1');
    ylabel('PC2');
    
    axes('position',[position_x3(2), position_y3(2), panel_width1, panel_height1]);
    plot(score(subsample_v,1),score(subsample_v,3),'.')
    xlim([-1 1])
    ylim([-1 1])
    xlabel('PC1');
    ylabel('PC3');
        title('PCA on x, y, linear velocity, angular velocity, onset');

    axes('position',[position_x3(3), position_y3(2), panel_width1, panel_height1]);
    plot(score(subsample_v,2),score(subsample_v,3),'.')
    xlim([-1 1])
    ylim([-1 1])
    xlabel('PC2');
    ylabel('PC3');
    
    
    
    %     histogram(score(:,3))
    if isempty(dir(dir_save_figure))
        mkdir (dir_save_figure)
    end
    filename=['kinematics'];
    figure_name_out=[ dir_save_figure filename];
    eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
    %     eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
    
    clf;
end

