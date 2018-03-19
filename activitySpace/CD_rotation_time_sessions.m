function  CD_rotation_time_sessions()
close all;

dir_save_figure ='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\Results\Population\activitySpace\Modes\Time\sessions\';

%% Graphics
figure
set(gcf,'DefaultAxesFontSize',7);
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 0 30 24]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[0 0 0 0]);

panel_width=0.17;
panel_height=0.17;
horizontal_distance=0.23;
vertical_distance=0.28;

position_x(1)=0.1;
position_x(2)=position_x(1)+horizontal_distance;
position_x(3)=position_x(2)+horizontal_distance;

position_y(1)=0.68;
position_y(2)=position_y(1)- vertical_distance;
position_y(3)=position_y(2)- vertical_distance;



%% Fetching and plotting
rel = (EXP.Session & EPHYS.TrialSpikes ) * EXP.SessionID * (ANL.CDrotation) ;
sess_uids= unique([fetchn(rel, 'session_uid', 'ORDER BY session_uid' )],'stable');
key.session_uid = sess_uids(1);
time = fetch1 (rel & key  & 'mode_mat_corr_id=1', 'mode_mat_timebin_vector');

% ALM left
%--------------------------------------------------------------------------
for i_s =1:1:numel(sess_uids)
    session_uid = sess_uids(i_s);
    key.session_uid = session_uid;
    subject_id = fetch1((EXP.SessionID * EXP.Session) & key, 'subject_id');
    session_date = fetch1((EXP.SessionID * EXP.Session) & key, 'session_date');
    brain_area = fetch1((EXP.SessionID * ANL.SessionPosition) & key, 'brain_area');
    hemisphere = fetch1((EXP.SessionID * ANL.SessionPosition) & key, 'hemisphere');

    filename = [brain_area hemisphere '_' num2str(subject_id) '_' session_date];
    
    axes('position',[position_x(1), position_y(1), panel_width, panel_height]);
    r1 = fetch1 (rel & key & 'mode_mat_corr_id=1','mode_mat_t_weights_corr');
    fn_plot_CD_rotation(time,r1);
    title(sprintf('%s %s \n anm%d  %s sid=%d \n trials without photostim \n', brain_area, hemisphere, subject_id, session_date, session_uid), 'FontSize',14);
    r1_s(i_s,:,:)=r1;

    axes('position',[position_x(2), position_y(1), panel_width, panel_height]);
    r2 = fetch1 (rel & key & 'mode_mat_corr_id=2','mode_mat_t_weights_corr');
    fn_plot_CD_rotation(time,r2);
    title(sprintf('\n all trials \n'), 'FontSize',14);
    
    fn_saveFigure (dir_save_figure, filename, 2);
    r2_s(i_s,:,:)=r2;
    clf;
end



