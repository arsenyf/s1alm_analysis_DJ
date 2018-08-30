function activitySpace_Modes()
% close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Population\activitySpace\Modes\projections\'];

flag_single_sessions =1; % 1 to analyze single sessions, 0 to average across sessions

key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'distractor'
key.unit_quality = 'ok or good'
key.cell_type = 'Pyr'
key.mode_weights_sign = 'all';
condition = 'mini'



if strcmp(condition,'mini')
    key.session_flag_mini = 1;
    key.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    key.session_flag_full = 1;
    key.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
    key.session_flag_full_late = 1;
    key.trialtype_flag_full_late = 1;
end

k = key;

if contains(key.hemisphere, 'both')
    k = rmfield(k, 'hemisphere');
end

%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);


Param = struct2table(fetch (ANL.Parameters,'*'));
smooth_time = Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
dir_save_figure = [dir_save_figure 'smooth' num2str(smooth_time) 's\']

rel =((EXP.Session * EXP.SessionID * ANL.ProjTrialAdaptiveAverage * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction *  ANL.IncludeSession * ANL.SessionGrouping * ANL.TrialTypeStimTime ) - ANL.ExcludeSession) & k & 'unit_quality!="multi"' ;

session_uid = unique(fetchn(rel, 'session_uid'));


for i_s = 1:1:numel(session_uid)
    key_session.session_uid = session_uid(i_s);
    
    if flag_single_sessions==1 % single session
        plotModes (rel & key_session,  Param);
        subject_id =  fetch1(rel & key_session,'subject_id', 'LIMIT 1');
        session_date=  fetch1(rel & key_session,'session_date', 'LIMIT 1');
        dir_save_figure_full = [dir_save_figure 'sessions\' key.brain_area '\' key.hemisphere '\' key.training_type '\' condition '\' key.cell_type '\' ];
    else %average acrposs sessions
        suffix =[];
        plotModes (rel,  Param);
        subject_id=[];
        session_date=[];
        key_session.session_uid=[];
        dir_save_figure_full = [dir_save_figure  '\' condition '\'  ];
    end
    
    axes('position',[0.05, 0.92, 0.2, 0.1]);
    text( 0,0 , sprintf('%s %s side   Training: %s    CellQuality: %s  Cell-type: %s     Animal %d    %s    session id %d' ,...
        key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type, subject_id,session_date,  key_session.session_uid),'HorizontalAlignment','Left','FontSize', 10);
    axis off;
    box off;
    
    
    
    if contains(key.unit_quality, 'ok or good')
        key.unit_quality = 'ok';
    end
    
    filename =[sprintf('%s%s_Training_%s_UnitQuality_%s_Type_%s_suid%d' ,key.brain_area, key.hemisphere, key.training_type, key.unit_quality, key.cell_type, key_session.session_uid )];
    
    if isempty(dir(dir_save_figure_full))
        mkdir (dir_save_figure_full)
    end
    figure_name_out=[ dir_save_figure_full filename];
    eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
    eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
    
    
    if flag_single_sessions==0 % average across sessions
        break
    end
    clf
end
end



