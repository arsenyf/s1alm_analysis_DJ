function analysis_RegressionModesScatterSessions()
close all;

key.regression_time_start=round(-0.2,4);


dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\video_tracking\analysis\RegressionModes_scatter_sessions2\' 't' num2str(key.regression_time_start) '\'];


figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -7 0 0]);

panel_width1=0.08;
panel_height1=0.15;
horizontal_distance1=0.3;
vertical_distance1=0.25;

position_x1(1)=0.06;
position_x1(2)=position_x1(1)+horizontal_distance1;
position_x1(3)=position_x1(2)+horizontal_distance1;
position_x1(4)=position_x1(3)+horizontal_distance1;
position_x1(5)=position_x1(4)+horizontal_distance1;
position_x1(6)=position_x1(5)+horizontal_distance1;
position_x1(7)=position_x1(6)+horizontal_distance1;


position_y1(1)=0.7;
position_y1(2)=position_y1(1)-vertical_distance1;
position_y1(3)=position_y1(2)-vertical_distance1;
position_y1(4)=position_y1(3)-vertical_distance1;
position_y1(5)=position_y1(4)-vertical_distance1;
position_y1(6)=position_y1(5)-vertical_distance1;
position_y1(7)=position_y1(6)-vertical_distance1;



rel_P=ANL.RegressionProjTrialNormalizedbetaXR2 *ANL.SessionPosition *EXP.SessionTraining;

% rel_significant_cells=ANL.RegressionUnitSignificance* ANL.SessionPosition*EXP.SessionTraining & ANL.RegressionDecoding2;


key.brain_area = 'ALM';
% key.hemisphere = 'Left';
% key.trialtype_left_and_right_no_distractors=1;
% key.training_type = 'regular';
% key.outcome = 'hit';

lick_direction_name{1}='all';
lick_direction_name{2}='right';
lick_direction_name{3}='left';


tuning_param_name_1D{1}='lick_horizoffset_relative';
tuning_param_name_1D{2}='lick_peak_x';
tuning_param_name_1D{3}='lick_rt_video_onset';

tuning_param_label{1}='ML';
tuning_param_label{2}='AP';
tuning_param_label{3}='ReactionTime';



sessions = unique(fetchn(rel_P*EXP.SessionID & key, 'session_uid'));


for i_p=1:1:numel(tuning_param_name_1D)
    for  i_d=1:1:numel(lick_direction_name)
        key.lick_direction=lick_direction_name{i_d};
        key.tuning_param_name =tuning_param_name_1D{i_p};
        
        %% Regression sessions
        for i_s=1:1:numel(sessions)
            key.session_uid = sessions(i_s);
            subplot(6,5,i_s);
            [R2_LinearRegression(i_s),R2_LogisticRegression(i_s)]=fn_plot_regression_scatter_session (rel_P,  key, tuning_param_label{i_p});
        end
        
        if isempty(dir(dir_save_figure))
            mkdir (dir_save_figure)
        end
        filename=['regression_' tuning_param_label{i_p} '_' lick_direction_name{i_d}];
        figure_name_out=[ dir_save_figure filename];
        eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
        clf
        
        if i_d==1
            subplot(2,2,1)
            hold on;
            plot(R2_LinearRegression,R2_LogisticRegression,'.')
            xlabel('Simple Linear Regression','Color',[0 0 1]);
            ylabel('Logistic Regression','Color',[1 0 1]);
            title('R^2');
            xl=[0,1];
            yl=xl;
            plot(xl,yl);
            xlim(xl);
            ylim(yl);
            
            filename=['R2_' tuning_param_label{i_p} '_' lick_direction_name{i_d}];
            figure_name_out=[ dir_save_figure filename];
            eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
            clf
        end
    end
end
