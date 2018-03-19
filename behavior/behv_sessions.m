function behv_sessions()

% clear all;
close all;

dir_save_figure ='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\Results\Behavior\performance\sessions\';

inclusion_behav_prcnt_early =fetch1(ANL.Parameters & 'parameter_name="inclusion_behav_prcnt_early"','parameter_value');
inclusion_behav_prcnt_hit =fetch1(ANL.Parameters & 'parameter_name="inclusion_behav_prcnt_hit"','parameter_value');


inclusion_behav_prcnt_hit =50; % a session with performance below this on pure left/right trials will be defined as session with "bad behavior";
inclusion_behav_prcnt_early =50; % a session with early-licks above this on pure left/right trials will be defined as session with "bad behavior"

% populate(ANL.SessionBehavPerformance);

%% Plotting the behavior performance

figure
set(gcf,'DefaultAxesFontSize',7);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 0 30 24]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[0 0 0 0]);

panel_width=0.15;
panel_height=0.15;
horizontal_distance=0.25;
vertical_distance=0.37;

position_x(1)=0.065;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;
position_x(4)=position_x(3)+horizontal_distance;
position_x(5)=position_x(4)+horizontal_distance;
position_x(6)=position_x(5)+horizontal_distance;

position_y(1)=0.6;
position_y(2)=position_y(1)-vertical_distance;
position_y(3)=position_y(2)-vertical_distance;
position_y(4)=position_y(3)-vertical_distance;
position_y(5)=position_y(4)-vertical_distance;


key_s = fetch(ANL.SessionBehavOverview & ANL.SessionBehavPerformance);

for ik=1:1:numel(key_s)
    
    k=[];
    k = key_s(ik);
    if ~isempty(fetch(EXP.SessionComment & k))
        continue
    end
    
    %% Fetching
    anm = fetch1(EXP.Session & k, 'subject_id');
    date = fetch1(EXP.Session & k, 'session_date');
    session_uid = fetch1(EXP.SessionID & k, 'session_uid');
    
    task_protocol = fetch1(EXP.SessionTask & k, 'task_protocol');
    training = fetch1(EXP.SessionTraining & k, 'training_type');
    has_ephys_flag = 'no';
    ephys_dir_suffix =[];
    if ~isempty(fetch(EPHYS.ElectrodeGroup & k))
        has_ephys_flag = 'yes';
        ephys_dir_suffix ='ephys\';
    end
    
    trials_hit = fetch1(ANL.SessionBehavOverview & k ,'trials_hit');
    trials_miss = fetch1(ANL.SessionBehavOverview & k ,'trials_miss');
    trials_ignore = fetch1(ANL.SessionBehavOverview & k ,'trials_ignore');
    trials_early = fetch1(ANL.SessionBehavOverview & k ,'trials_early');
    trials_quit = fetch1(ANL.SessionBehavOverview & k ,'trials_quit');
    
    trial_type_names =  fetchn(ANL.SessionBehavPerformance & k, 'trial_type_name', 'ORDER BY trial_type_num');
    percent_hit =  fetchn(ANL.SessionBehavPerformance & k, 'prcnt_hit', 'ORDER BY trial_type_num');
    prcnt_hit_outof_noignore  =  fetchn(ANL.SessionBehavPerformance & k, 'prcnt_hit_outof_noignore', 'ORDER BY trial_type_num');
    prcnt_hit_outof_noignore_noearly =  fetchn(ANL.SessionBehavPerformance & k, 'prcnt_hit_outof_noignore_noearly', 'ORDER BY trial_type_num');
    percent_ignore =  fetchn(ANL.SessionBehavPerformance & k, 'prcnt_ignore', 'ORDER BY trial_type_num');
    percent_early =  fetchn(ANL.SessionBehavPerformance & k, 'prcnt_early', 'ORDER BY trial_type_num');
    total_behaving =  fetchn(ANL.SessionBehavPerformance & k, 'total_behaving', 'ORDER BY trial_type_num');
    total_noignore_noearly =  fetchn(ANL.SessionBehavPerformance & k, 'total_noignore_noearly', 'ORDER BY trial_type_num');
    
    R_trials=fetchn(ANL.SessionBehavPerformance & k & 'trial_instruction="right"', 'trial_type_num', 'ORDER BY trial_type_num');
    L_trials=fetchn(ANL.SessionBehavPerformance & k & 'trial_instruction="left"', 'trial_type_num', 'ORDER BY trial_type_num');
    
    RT_hit_mean =  fetchn(ANL.SessionBehavPerformance & k, 'mean_reaction_time_hit', 'ORDER BY trial_type_num');
    RT_hit_stem =  fetchn(ANL.SessionBehavPerformance & k, 'stem_reaction_time_hit', 'ORDER BY trial_type_num');
    RT_miss_mean =  fetchn(ANL.SessionBehavPerformance & k, 'mean_reaction_time_miss', 'ORDER BY trial_type_num');
    RT_miss_stem =  fetchn(ANL.SessionBehavPerformance & k, 'stem_reaction_time_miss', 'ORDER BY trial_type_num');
    
    trn_pure_r=find(cellfun(@strcmp, trial_type_names, repmat({'r'},numel(trial_type_names),1)));
    trn_pure_l=find(cellfun(@strcmp, trial_type_names, repmat({'l'},numel(trial_type_names),1)));
    trn_pure_l_SMini=find(cellfun(@strcmp, trial_type_names, repmat({'l_-2.5Mini'},numel(trial_type_names),1)));
    
    flag_psychometric =0;
    if ~isempty(trn_pure_l_SMini)
        if total_behaving(trn_pure_l_SMini) >=0.5* sum(total_behaving(L_trials))
            k_comment = k;
            session_comment  ='psychometric curve';
            k_comment.session_comment =session_comment;
            flag_psychometric =1;
        end
    end
    if flag_psychometric==0
        if ~isempty(trn_pure_l)
            %check if the performance is bad
            if (prcnt_hit_outof_noignore(trn_pure_r) < inclusion_behav_prcnt_hit || prcnt_hit_outof_noignore(trn_pure_l) < inclusion_behav_prcnt_hit)...
                    || (percent_early(trn_pure_r) >=  inclusion_behav_prcnt_early || percent_early(trn_pure_l) >= inclusion_behav_prcnt_early)
                k_comment = k;
                session_comment  ='bad behavior';
                k_comment.session_comment =session_comment;
            else
                k_comment = k;
                session_comment  ='good behavior';
                k_comment.session_comment =session_comment;
            end
        else
            k_comment = k;
            session_comment  ='psychometric curve';
            k_comment.session_comment =session_comment;
        end
    end
    insert(EXP.SessionComment, k_comment);
    
    %% Plotting
    % Session trials overview
    axes('position',[position_x(1), 0.85, 0.9, 0.07]);
    hold on;
    plot(trials_hit,1,'.g')
    plot(trials_miss,1,'.r')
    if ~isempty (trials_ignore)
        plot(trials_ignore,1,'.k','MarkerSize',8)
    end
    if ~isempty (trials_early)
        plot(trials_early,1.5,'.b','MarkerSize',8)
    end
    if ~isempty (trials_quit)
        plot(trials_quit,2,'.k','MarkerSize',8);
    end
    ylim([0 3])
    title(sprintf('anm%d   %s   ephys recording: %s     task %d        training: %s     \n Session %d  %s   ',anm, date , has_ephys_flag, task_protocol, training, session_uid, session_comment),'FontSize',12);
    box off;
    xlabel('Trials');
    set(gca, 'FontSize', 12,'Ytick', []);
    
    % Total trials
    axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
    bar(R_trials,total_noignore_noearly(R_trials), 'FaceColor', [0 0 1])
    hold on;
    bar(L_trials, total_noignore_noearly(L_trials), 'FaceColor', [1 0 0])
    ylabel('Trials (excluding early licks and quit)')
    xlim([0 numel(trial_type_names)+1]);
    set(gca, 'Xtick', 1:numel(trial_type_names), 'XtickLabel', trial_type_names, 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 90);
    box off;
    
    %Performance
    axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
    bar(R_trials,percent_hit(R_trials), 'FaceColor', [0 0 1])
    hold on;
    bar(L_trials, percent_hit(L_trials), 'FaceColor', [1 0 0])
    hold on
    plot([1 numel(percent_hit)],[inclusion_behav_prcnt_hit inclusion_behav_prcnt_hit],'--k');
    ylabel(sprintf('%% Correct \nwith early licks and ignore'))
    ylim([0 100]);
    xlim([0 numel(trial_type_names)+1]);
    set(gca, 'Xtick', 1:numel(trial_type_names), 'XtickLabel', trial_type_names, 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 90);
    box off;
    
    axes('position',[position_x(3), position_y(1), panel_width, panel_height]);
    bar(R_trials,prcnt_hit_outof_noignore(R_trials), 'FaceColor', [0 0 1])
    hold on;
    bar(L_trials, prcnt_hit_outof_noignore(L_trials), 'FaceColor', [1 0 0])
    hold on
    plot([1 numel(prcnt_hit_outof_noignore)],[inclusion_behav_prcnt_hit inclusion_behav_prcnt_hit],'--k');
    ylabel(sprintf('%% Correct \nwith early-licks, without ignore'))
    ylim([0 100]);
    xlim([0 numel(trial_type_names)+1]);
    set(gca, 'Xtick', 1:numel(trial_type_names), 'XtickLabel', trial_type_names, 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 90);
    box off;
    
    axes('position',[position_x(4), position_y(1), panel_width, panel_height]);
    bar(R_trials,prcnt_hit_outof_noignore_noearly(R_trials), 'FaceColor', [0 0 1])
    hold on;
    bar(L_trials, prcnt_hit_outof_noignore_noearly(L_trials), 'FaceColor', [1 0 0])
    hold on
    plot([1 numel(prcnt_hit_outof_noignore_noearly)],[inclusion_behav_prcnt_hit inclusion_behav_prcnt_hit],'--k');
    ylabel(sprintf('%% Correct \nwithout early licks or ignore'))
    ylim([0 100]);
    xlim([0 numel(trial_type_names)+1]);
    set(gca, 'Xtick', 1:numel(trial_type_names), 'XtickLabel', trial_type_names, 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 90);
    box off;
    
    % Ignore
    axes('position',[position_x(1), position_y(2), panel_width, panel_height]);
    bar(R_trials,percent_ignore(R_trials), 'FaceColor', [0 0 1])
    hold on;
    bar(L_trials, percent_ignore(L_trials), 'FaceColor', [1 0 0])
    ylabel('% Ignore')
    ylim([0 100]);
    xlim([0 numel(trial_type_names)+1]);
    set(gca, 'Xtick', 1:numel(trial_type_names), 'XtickLabel', trial_type_names, 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 90);
    box off;
    
    % Early lick
    axes('position',[position_x(2), position_y(2), panel_width, panel_height]);
    bar(R_trials,percent_early(R_trials), 'FaceColor', [0 0 1])
    hold on;
    bar(L_trials, percent_early(L_trials), 'FaceColor', [1 0 0])
    ylabel('% Early lick');
    plot([1 numel(percent_early)],[inclusion_behav_prcnt_early inclusion_behav_prcnt_early],'--k');
    ylim([0 100]);
    xlim([0 numel(trial_type_names)+1]);
    set(gca, 'Xtick', 1:numel(trial_type_names), 'XtickLabel', trial_type_names, 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 90);
    box off;
    
    
    % Reaction times
    axes('position',[position_x(3), position_y(2), panel_width, panel_height]);
    hold on
    bar(R_trials,RT_hit_mean(R_trials), 'FaceColor', [0 0 1])
    errorbar_myown( R_trials, RT_hit_mean(R_trials) ,R_trials*0, RT_hit_stem(R_trials), '.b', 0.1 );
    bar(L_trials, RT_hit_mean(L_trials), 'FaceColor', [1 0 0])
    errorbar_myown( L_trials, RT_hit_mean(L_trials) ,L_trials*0, RT_hit_stem(L_trials), '.r', 0.1 );
    ylabel('Reaction Time Correct(s)')
    ylim([0 nanmax([RT_hit_mean;RT_miss_mean])]);
    xlim([0 numel(trial_type_names)+1]);
    set(gca, 'Xtick', 1:numel(trial_type_names), 'XtickLabel', trial_type_names, 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 90);
    box off;
    
    axes('position',[position_x(4), position_y(2), panel_width, panel_height]);
    hold on;
    bar(R_trials,RT_miss_mean(R_trials), 'FaceColor', [0 0 1])
    errorbar_myown( R_trials, RT_miss_mean(R_trials) ,R_trials*0, RT_miss_stem(R_trials), '.b', 0.1 );
    bar(L_trials, RT_miss_mean(L_trials), 'FaceColor', [1 0 0])
    errorbar_myown( L_trials, RT_miss_mean(L_trials) ,L_trials*0, RT_miss_stem(L_trials), '.r', 0.1 );
    ylabel('Reaction Time Error (s)')
    ylim([0 nanmax([RT_hit_mean;RT_miss_mean])]);
    xlim([0 numel(trial_type_names)+1]);
    set(gca, 'Xtick', 1:numel(trial_type_names), 'XtickLabel', trial_type_names, 'TickLabelInterpreter', 'None', 'FontSize', 12, 'XTickLabelRotation', 90);
    box off;
    
    
    if strcmp(session_comment,'bad behavior')
        dir_save_figure_full =[dir_save_figure ephys_dir_suffix 'bad_behavior\'];
    elseif strcmp(session_comment,'psychometric curve')
        dir_save_figure_full =[dir_save_figure ephys_dir_suffix 'psychometric_curve\'];
    elseif strcmp(session_comment,'good behavior')
        dir_save_figure_full =[dir_save_figure ephys_dir_suffix];
    end
    
    % Saving Figure
    %--------------------------------------------------------------------------
    filename = [num2str(anm) '_' date '_task' num2str(task_protocol)];
    if isempty(dir(dir_save_figure_full))
        mkdir (dir_save_figure_full)
    end
    figure_name_out=[ dir_save_figure_full filename];
    eval(['print ', figure_name_out, ' -dtiff -cmyk -r100']);
    %     eval(['print ', figure_name_out, ' -dpdf -cmyk -r100']);
    
    clf;
end
