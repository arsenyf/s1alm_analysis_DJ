function activitySpace_Modes()
close all;

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\'
dir_save_figure = [dir_root 'Results\Results\Population\activitySpace\Modes\'];


key.brain_area = 'ALM'
key.hemisphere = 'left'
key.training_type = 'distractor'
key.unit_quality = 'ok or good'
key.cell_type = 'all'
condition = 'full'

if strcmp(condition,'mini')
    key.session_flag_mini = 1;
    key_mode.trialtype_flag_mini = 1;
elseif strcmp(condition,'full')
    key.session_flag_full = 1;
    key_mode.trialtype_flag_full = 1;
elseif strcmp(condition,'full_late')
    key.session_flag_full_late = 1;
    key_mode.trialtype_flag_full_late = 1;
end

k = key;
    rel =(EXP.Session * EXP.SessionID * ANL.ProjTrialAverage * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction * EXP.SessionComment * ANL.IncludeSession) & k & 'unit_quality!="multi"' & 'good_session_flag=1';

% if contains(k.unit_quality,'ok or good')
%     k = rmfield(k,'unit_quality');
%     rel =(EXP.Session * EXP.SessionID * ANL.ProjTrialAverage * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction * EXP.SessionComment * ANL.IncludeSession) & k & 'unit_quality!="multi"' & 'good_session_flag=1';
% else
%     if contains(k.unit_quality,'all')
%         k = rmfield(k,'unit_quality');
%     end
%     rel =(EXP.Session * EXP.SessionID * ANL.ProjTrialAverage * EXP.SessionTraining  * ANL.TrialTypeID * ANL.TrialTypeGraphic * ANL.TrialTypeInstruction * EXP.SessionComment * ANL.IncludeSession) & k & 'good_session_flag=1';
% end




%Graphics
%---------------------------------
figure;
set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 35 30]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);


Param = struct2table(fetch (ANL.Parameters,'*'));


% modeNames = {'Stimulus','EarlyDelay','LateDelay','Ramping'};
    plotModes (rel,  Param, key_mode);





%
%     % Saving Figure
%     %--------------------------------------------------------------------------
%
%
%     anm_name = num2str(Unit.subject_id);
%     date =  Unit.session_date;
%     brain_area = Unit.brain_area;
%     hemisphere = Unit.hemisphere;
%     %         dir_name =  [dir_save_figure brain_area '\' hemisphere '\' anm_name '\' date];
%     dir_name =  [dir_save_figure brain_area '\' hemisphere '\' training '\' ];
%
%     %         if exist(dir_name)
%     %             [status, message, messageid] = rmdir (dir_name,'s')
%     %         end
%
%
%
%     cell_type=Unit.cell_type;
%     if contains(cell_type,'not classified')
%         cell_type='not_classified';
%     end
%
%     if rel5.count>0
%         accept_cell_flag=1;
%         if contains(Unit.unit_quality,'multi') %multi units
%             dir_save_cell = [dir_name 'multi_units\'  cell_type '\'];
%         else %single units
%             dir_save_cell = [dir_name 'single_units\'  cell_type '\'];
%         end
%     else  % rejected cells
%         dir_save_cell = [dir_name '\rejected\'];
%     end
%
%     if isempty(dir(dir_save_cell))
%         mkdir (dir_save_cell)
%     end
%     figure_name_out=[dir_save_cell 'anm' anm_name '_' date '_uid_' num2str(Unit.unit_uid)];
%     eval(['print ', figure_name_out, ' -dtiff -cmyk -r200']);

clf;


